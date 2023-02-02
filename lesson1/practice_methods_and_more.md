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

What is the return value of the following statement? Why?

```ruby
['ant', 'bear', 'caterpillar'].pop.size
```

---

The return value will be:

```
11
```

This is because we are chaining methods. First, the `pop` method is invoked, which removes the last element from the array it was called on, mutating it, then it returns that value. In this case it returns the string `'caterpillar'`.

We then invoke the method `size` on the return value from calling `pop`. Since it's the string `'caterpillar'`, it returns how many characters this string has, which is `11`, therefore it returns `11`.

---

7.What is the block's return value in the following code? How is it determined? Also, what is the return value of any? in this code and what does it output?

```ruby
[1, 2, 3].any? do |num|
  puts num
  num.odd?
end
```

---

Overall this code will return `true`. This is because the `any?` method iterates over a collection and passes the element to a block and takes note of the return value. If any of the elements when passed to the block evaluate as true(is truthy), then `any?` returns `true`.

In this case, the last expression in the block is `nom.odd?`, where `num` is the parameter that was passed the element as an argument. Since both `1` and `3` are elements and are odd, we know that this block will evaluate as `true` at least once.

This code ouptuts:

```
1
```

This is because the first element is odd, therefore `any?` does not need to further iterate because it already knows it will return `true`. It's programmed like an `||`.

---

8.How does take work? Is it destructive? How can we find out?

```ruby
arr = [1, 2, 3, 4, 5]
arr.take(2)
```

[Ruby docs](https://docs.ruby-lang.org/en/master/Array.html#method-i-take) explains `take` as:

```
Returns a new Array containing the first n element of self, where n is a non-negative Integer; does not modify self.
```

So in this case, `take` will return `[1, 2]` and `arr` will still be `[1, 2, 3, 4, 5]` because `take` is not destructive.

---

9.What is the return value of map in the following code? Why?

```ruby
{ a: 'ant', b: 'bear' }.map do |key, value|
  if value.size > 3
    value
  end
end
```

---

`map` is defined in `Enumerable`, which `Hash` uses. `map` creates a new array, iterates over a collection passing each element as an argument to a provided block each iteration, and adds blocks the return value to the new array, which it returns when it has finished iterating.

In this case, it will return the value of the key value pair, which was passed as an argument into the parameter `value`, only if the `size` method invoked on it returns a value larger than `3`. If it does not, it will return `nil`. This is because the `if` statement itself will return `nil`. Therefore, `map` will return `[nil, 'bear']`.

---

10.What is the return value of the following code? Why?

```ruby
[1, 2, 3].map do |num|
  if num > 1
    puts num
  else
    num
  end
end
```

---

I explained `map` in the last example. In this case, let's take the iterations step by step to understand what each iterations block returns and how we get the answer.

The first element `map` will iterate over is `1`. `1` is passed as an argument to the block and the parameter `num` is assigned to it. On line 180, we use an `if` conditional to check if `num` is greater than `1`, it is not since it is `1`, so we do not execute the xpression on line 181, instead going to the elese on 182 and running the expression on 183, which is `num`. Therefore the first element passed to the block causes it to return `1`.

The second element `map` will iterate over is `2`. `num` is assigned to `2`. `2` is greater than `1`, so we execute the expression on line 181, invokings the `puts` method passing `num`s object reference as an argument. This outputs `2` and returns `nil`. This will be the last expression evaluated in the block, thus the block returns `nil`.

Finally, the third element is `3`. Like `2` it's greater than `1`, so it's output and the block returns `nil`.

`map` is done iterating and returns the array `[1, nil, nil]` and while it was iterating output:

```
2
3
```
