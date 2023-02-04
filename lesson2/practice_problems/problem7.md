Given this code, what would be the final values of a and b? Try to work this out without running the code.

```ruby
a = 2
b = [5, 8]
arr = [a, b]

arr[0] += 2
arr[1][0] -= a
```

`a` will still refer to the integer `2` at the end of this. This is because integers are immutable, thus since we do not reassign `a`, its object cannot change.

`b` will be `[3, 8]` instead. By assigning the second element of the array to the reference `b` carries, when we reference the sub array referred to by `arr[1]` on line 6, we are referencing the same array pointed to by `b`. The `[0] -= a` on line 6 after `arr[1]` is ruby syntactic sugar that is shorthand for `#[0]= arr[0] - 2`. `#[]=` is a setter and it mutates the array it is called on, so this applies to the array referenced by both `b` and `arr[1]`.
