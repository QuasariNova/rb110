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

3.What is the return value of reject in the following code? Why?

```ruby
[1, 2, 3].reject do |num|
  puts num
end
```

---

`reject` returns a new array of objects rejected by the block, so it is like the opposite of `select` in that it selects it's elements based on the block returning a falsy value. In this case, it will return:

```
[1, 2, 3]
```

This is because the `puts` method returns `nil` which is falsy.

---

4.What is the return value of `each_with_object` in the following code? Why?

```ruby
['ant', 'bear', 'cat'].each_with_object({}) do |value, hash|
  hash[value[0]] = value
end
```

---

It will return:
```
{
  'a' => 'ant',
  'b' => 'bear',
  'c' => 'cat'
}
```

`each_with_object` takes an object reference as an argument, which we pass an empty hash in this case. `each_with_object` will then use this object as it's return value and will pass it to the block as an argument ever iteration.

In this case, we are using the first character of each string in the array as a key to store the element as a value in the hash we call `hash`. Once `each_with_object` full iterates over the collection, it returns the hash that we have been referring to as `hash` inside the block.

---

5.What does shift do in the following code? How can we find out?

```ruby
hash = { a: 'ant', b: 'bear' }
hash.shift
```

---
`shift` in this context will permanently remove the first key value pair from the hash and return that key value pair as a 2 element array. I found that [here](https://docs.ruby-lang.org/en/master/Hash.html#method-i-shift)

---
