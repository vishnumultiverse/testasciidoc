#!/usr/bin/env ruby

require 'asciidoctor'
require 'json'

class LevelBasedFlowConverter < Asciidoctor::Converter::Base
  register_for 'json'
  
  def initialize(backend, opts = {})
    super
    @backend = backend
  end
  
  def convert_document(node)
    result = {
      document: {
        title: node.title || node.attributes['doctitle'],
        flows: []
      }
    }
    
    special_attrs = ['competency_id', 'unit_thumbnail']
    special_attrs.each do |attr|
      result[:document][attr] = node.attr(attr) if node.attr?(attr)
    end
    
    node.blocks.each do |block|
      if block.context == :section && block.level == 0
        flow = process_flow(block)
        result[:document][:flows] << flow
      end
    end
    
    JSON.pretty_generate(result)
  end
  
  def convert_embedded(node)
    convert(node)
  end
  
  def convert(node, transform = nil)
    case node.node_name
    when 'document'
      convert_document(node)
    when 'section'
      JSON.generate(process_section(node))
    else
      JSON.generate({ content: node.content })
    end
  end
  
  private
  
  def extract_attributes_from_content(content)
    attributes = {}
    content_str = content.to_s
    
    if content_str =~ /\[\.attributes\]\s*(.*?)(?=\n\n|\n\[|\z)/m
      attrs_text = $1.strip
      
      attrs_text.split(',').each do |pair|
        pair = pair.strip
        if pair =~ /(.+?)=(.+)/
          key = $1.strip
          value = $2.strip
          
          case key
          when /^(min_words|time|max_length|min_length)$/
            attributes[key] = value.to_i
          when /^(mandatory|optional|allow_editing|allow_attachments)$/
            attributes[key] = (value.downcase == 'true')
          else
            attributes[key] = value
          end
        end
      end
    end
    
    puts "Extracted attributes: #{attributes.inspect}" unless attributes.empty?
    
    attributes
  end
  
  def clean_content(content)
    content.to_s.gsub(/\[\.attributes\].*?(?=\n\n|\n\[|\z)/m, '').strip
  end
  
  def process_flow(flow_section)
    flow = {
      id: flow_section.id,
      title: flow_section.title,
      level: flow_section.level,
      activities: []
    }
    
    puts "Processing flow: #{flow[:title]}"
    
    flow_content = ""
    
    flow_section.blocks.each do |block|
      if block.context == :section && block.level == 1
        activity = process_activity(block)
        flow[:activities] << activity
      else
        flow_content += block.content.to_s + "\n\n"
      end
    end
    
    flow_attributes = extract_attributes_from_content(flow_content)
    
    flow.merge!(flow_attributes)
    
    clean_flow_content = clean_content(flow_content)
    flow[:content_html] = clean_flow_content unless clean_flow_content.empty?
    
    flow
  end
  
  def process_activity(activity_section)
    activity = {
      id: activity_section.id,
      title: activity_section.title,
      level: activity_section.level
    }
    
    puts "Processing activity: #{activity[:title]}"
    
    activity_content = ""
    
    activity_section.blocks.each do |block|
      activity_content += block.content.to_s + "\n\n"
    end
    
    activity_attributes = extract_attributes_from_content(activity_content)
    
    activity.merge!(activity_attributes)
    
    clean_activity_content = clean_content(activity_content)
    activity[:content_html] = clean_activity_content unless clean_activity_content.empty?
    
    activity
  end
  
  def process_section(section)
    section_obj = {
      id: section.id,
      title: section.title,
      level: section.level
    }
    
    puts "Processing section: #{section_obj[:title]}"
    
    section_content = ""
    
    section.blocks.each do |block|
      section_content += block.content.to_s + "\n\n"
    end
    
    section_attributes = extract_attributes_from_content(section_content)
    
    section_obj.merge!(section_attributes)
    
    clean_section_content = clean_content(section_content)
    section_obj[:content_html] = clean_section_content unless clean_section_content.empty?
    
    section_obj
  end
end

if ARGV.length < 1
  puts "Usage: ruby nested_struct.rb [input_file] [output_file]"
  exit 1
end

input_file = ARGV[0]
output_file = ARGV[1] || "#{File.basename(input_file, '.*')}.json"

unless File.exist?(input_file)
  puts "Error: Input file '#{input_file}' not found"
  exit 1
end

puts "Converting '#{input_file}' to JSON..."

begin
  begin
    json_output = Asciidoctor.convert_file(
      input_file,
      backend: 'json',
      safe: :safe,
      to_file: false,
      attributes: {
        'sectids' => '',
        'idprefix' => '',
        'idseparator' => '-'
      },
      doctype: 'book'
    )
    
    File.write(output_file, json_output)
    puts "Successfully converted to #{output_file}"
  rescue => e
    puts "First conversion attempt failed: #{e.message}"
    
    puts "Trying direct document parsing..."
    
    doc = Asciidoctor.load_file(
      input_file,
      safe: :safe,
      doctype: 'book',
      attributes: {
        'sectids' => '',
        'idprefix' => '',
        'idseparator' => '-'
      }
    )
    
    converter = LevelBasedFlowConverter.new('json')
    json_output = converter.convert(doc)
    
    File.write(output_file, json_output)
    puts "Successfully converted using direct parsing to #{output_file}"
  end
rescue => e
  puts "All conversion methods failed: #{e.message}"
  puts e.backtrace[0..3]
  
  begin
    puts "Creating minimal document structure using level-based rules..."
    
    file_content = File.read(input_file)
    
    puts "Checking for [.attributes] blocks in file..."
    attribute_matches = file_content.scan(/\[\.attributes\]/)
    puts "Found #{attribute_matches.size} attribute blocks in file"
    
    competency_id = nil
    if file_content =~ /:competency_id:\s*(.+?)$/m
      competency_id = $1.strip
    end
    
    flows = []
    
    flow_pattern = /^=\s+(.+?)$(.+?)(?=^=\s|\z)/m
    file_content.scan(flow_pattern) do |title, content|
      flow = {
        title: title.strip,
        activities: []
      }
      
      puts "Checking flow '#{title.strip}' for attributes"
      if content =~ /\[\.attributes\]\s*(.*?)(?=\n\n|\n\[|\z)/m
        attrs_text = $1.strip
        puts "Found attributes in flow: #{attrs_text}"
        
        attrs_text.split(',').each do |pair|
          if pair =~ /(.+?)=(.+)/
            key = $1.strip
            value = $2.strip
            
            case key
            when /^(min_words|time|max_length|min_length)$/
              flow[key] = value.to_i
            when /^(mandatory|optional|allow_editing|allow_attachments)$/
              flow[key] = (value.downcase == 'true')
            else
              flow[key] = value
            end
          end
        end
      end
      
      activity_pattern = /^==\s+(.+?)$(.+?)(?=^==\s|^=\s|\z)/m
      content.scan(activity_pattern) do |activity_title, activity_content|
        activity_obj = {
          title: activity_title.strip
        }
        
        puts "Checking activity '#{activity_title.strip}' for attributes"
        if activity_content =~ /\[\.attributes\]\s*(.*?)(?=\n\n|\n\[|\z)/m
          attrs_text = $1.strip
          puts "Found attributes in activity: #{attrs_text}"
          
          attrs_text.split(',').each do |pair|
            if pair =~ /(.+?)=(.+)/
              key = $1.strip
              value = $2.strip
              
              case key
              when /^(min_words|time|max_length|min_length)$/
                activity_obj[key] = value.to_i
              when /^(mandatory|optional|allow_editing|allow_attachments)$/
                activity_obj[key] = (value.downcase == 'true')
              else
                activity_obj[key] = value
              end
            end
          end
        end
        
        clean_content = activity_content.gsub(/\[\.attributes\].*?(?=\n\n|\n\[|\z)/m, '').strip
        activity_obj[:content_preview] = clean_content[0..100] + "..." unless clean_content.empty?
        
        flow[:activities] << activity_obj
      end
      
      flows << flow
    end
    
    minimal_doc = {
      document: {
        title: "Converted from #{input_file}",
        competency_id: competency_id,
        flows: flows
      }
    }
    
    File.write(output_file, JSON.pretty_generate(minimal_doc))
    puts "Created minimal JSON structure at #{output_file}"
  rescue => e
    puts "Failed to create even minimal JSON: #{e.message}"
    exit 1
  end
end
