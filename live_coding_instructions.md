Let's consider a survey that has these responses:

* Response #1
  * Answers: Q1: 5, Q2: 1
* Response #2
  * Answers: Q1: 2, Q2: 1

Your `Survey#answer_breakdown` method would currently return this data for question #1:

```
{
  1 => 0,
  2 => 1,
  3 => 0,
  4 => 0,
  5 => 1
}
```

Your `Survey#answer_breakdown` works currently with _all_ the responses for the survey, providing the answer breakdown across all responses for the survey.

We will change this method to now take two arguments: a `question` and a list of `segments`, and then `answer_breakdown` will only return the answers for matching responses:

```ruby
def answer_breakdown(question, segments)
  # your code goes here
end
```

A response is considered "matching" if it has _all_ of the specified segments. For instance, imagine the above responses now have segments:

* Response #1
  * **Segments: Melbourne, Male**
  * Answers: Q1: 5, Q2: 1

* Response #2
  * **Segments: Melbourne, Female**
  * Answers: Q1: 2, Q2: 1
  

If we were to call `answer_breakdown` and ask it to give us the answer breakdown for `Q1` and the segment list of `["Melbourne"]`, it would still return us the same result as before:

```ruby
{
  1 => 0,
  2 => 1,
  3 => 0,
  4 => 0,
  5 => 1
}
```

This is because both responses have the segment "Melbourne". But if we were to ask it for all responses that matched `["Melbourne", "Female"]`, only the 2nd response would be included and the output from this method would be:

```ruby
{
  1 => 0,
  2 => 1,
  3 => 0,
  4 => 0,
  5 => 0
}
```

The first response doesn't match because it doesn't have the segment "Female".

Your job is to convert `answer_breakdown` to support this new requirement of filtering the responses to only include those with the matching segments.

You can choose to modify any other code in your application if you wish.