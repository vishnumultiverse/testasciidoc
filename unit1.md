---
unit_title: Crafting Effective Prompts for Microsoft 365 Copilot
competency_id: 8fcf6358-338e-46c1-9615-3a323ac0a88a
unit_thumbnail: module21
# No solution for completion/visibility rules yet
# Not addressing separation by tag
# Not addressing submission format settings in submission activity
# Sphere Engine?
# Multimedia? Attached files? Videos? Asset management?
# Light and Full preview functionality.
# Nested fencing for nested blocks? What do we actually nest? Maybe just accordions.
---

# Flow title 1

## Activity title 1 {type=content,mandatory=true}

### Content H1

#### Content H2

##### Content H3

Regular text, **with some bold,** _some italic,_ ~~some strikethrough~~, and *underlined text*. And [hyperlinks of course](https://www.multiverse.io/en-GB).

* Regular
* Bullet
* Lists

and

1. Numbered
2. Bullet
3. List

Horizontal divider:

---

Quote:

> The way to get started is to quit talking and begin doing.
> 
> _Walt Disney_

Even complex math formulas:

$S (ω)=1.466\, H_s^2 \,  \frac{ω_0^5}{ω^6 }  \, e^[-3^ { ω/(ω_0  )]^2}$

We can use `inline code` when talking about technical terms such as `https`.

```javascript
// We can also showcase a block of code: 
let x = 5; 
let y = 2; 
let z = x % y;
```

```accordion
Something here that goes inside an accordion
```

```highlight
Write highlight here
```

```engagement_prompt
Write example here
```

```tip
Write example here
```

```example
Write example here
```

```resource_list
Write example here
```

```stepper
Step 1 here
```
```stepper
Step 2 here
```
Something here
```stepper
Step 1 here
```

## Form activity title {type=form,mandatory=true,allow_editing=true,is_survey=false}

Content above the form

```form_question_text {optional=false,min_words=1}
question text here
```

```form_question_multiple_choice {optional=false,require_additional_comment=false,randomize_order=false,select_multiple=false}
question text here
```
```form_question_multiple_choice_answer
option 1 here
```
```form_question_multiple_choice_answer
option 2 here
```

```form_question_video {optional=false,require_additional_comment=true,allow_screencast=true,allow_webcame=true,max_length=2}
Question text here
```

```form_question_number_scale {optional=false,require_additional_comment=true,min_range=1,max_range=10}
Question text here
```

```form_question_stack_ranking {optional=false,require_additional_comment=false,randomize_order=false}
Question text here
```
```form_question_stack_ranking_answer
option 1 here
```
```form_question_stack_ranking_answer
option 2 here
```

```form_question_info_block
Info text here
```

Content below the form

## Submission activity title {type=submission,mandatory=true,multiple_attachments=true,applied_learning_evidence=false,allow_editing=true}

Content above the submission

## Quiz activity title {type=quiz,reveal_correct_answers=always/selected/never,allow_retries=true,knowledge_check=true,mandatory=true}

Content above the quiz

```quiz_question_multiple_choice_single_select
Q1 text here
```
```quiz_answer {correct=true}
Q1 A1 text here
```
```quiz_answer_help_text
Q1 A2 helper text here
```
```quiz_answer {correct=false}
Q1 A2 text here
```

```quiz_question_multiple_choice_multi_select
Q2 text here
```
```quiz_answer {correct=true}
Q2 A1 text here
```
```quiz_answer {correct=true}
Q2 A2 text here
```

```quiz_question_open_ended
Q3 text here
```

```quiz_question_number_match {accepted_error=0.8}
Q4 text here
```
```quiz_answer
Q4 answer value here (a number)
```

```quiz_question_text_match
Q5 text here
```
```quiz_answer
Q5 A1 accepted answer
```
```quiz_answer
Q5 A2 accepted answer
```

Content below the quiz


## Self review activity title {type=self_review_no_submission,mandatory=false,allow_editing=true}
Content above self-review

[Initially just support self review without submission source]: #

```rubric_item_text {min_words=1,optional=false}
question text here
```

```rubric_item_scale {optional=false,require_additional_comment=true}
question text here
```
```rubric_item_scale_level
scale level 1 (worst) here
```
```rubric_item_scale_level
scale level 2 here
```
```rubric_item_scale_level
scale level 3 (best) here
```

```rubric_item_video {optional=false,require_additional_comment=true,allow_screencast=true,allow_webcame=true,max_length=2}
question text here
```

```rubric_item_number {optional=false,require_additional_comment=true,min_range=1,max_range=10}
question text here
```

```rubric_item_info
info text here
```


## Scoring activity title {type=final_scoring,mandatory=true}
Content above scoring table


## Discussion activity title {type=discussion,post_requirement=1,comment_requirement=1,post_comment_requirement=and,mandatory=false}
Content above the discussion


## Checklist activity title {type=checklist,mandatory=true}
Content above the checklist
```checklist_item
Item 1 here
```
```checklist_item
Item 2 here
```
Content below the checklist