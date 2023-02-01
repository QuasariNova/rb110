1. What is the return value of the select method below? Why?

```ruby
[1, 2, 3].select do |num|
  num > 5
  'hi'
end
```

---

The return value of the `select` method above will be:

```
[1, 2, 3]
```

This is because `select` iterates over the callers collection passing each element as an argument to the given block, creates a new array and only adds elements that the block evaluates as `true`. In this case, every time the block defined between lines 4 and 7 executes the return value will be `'hi'` and that evaluates as `true` since it is neither `false` or `nil`.

---

2.How does count treat the block's return value? How can we find out?

```ruby
['ant', 'bat', 'caterpillar'].count do |str|
  str.length < 4
end
```

---

`count` uses the return value of the block to know what to count. If it evaluates as `true` it adds one to it's potential return value, if it evaluates as `false` it does not. You can read the documentation [here](https://docs.ruby-lang.org/en/master/Enumerable.html#method-i-count) which states:

```
With a block given, calls the block with each element and returns the number of elements for which the block returns a truthy value
```
---
