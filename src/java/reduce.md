# `reduce` in Java

The [reduce](https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#reduce-T-java.util.function.BinaryOperator-) function below will just work fine.

```java
Integer sum = integers.reduce(0, (a, b) -> a+b);

```

However, when the arguments paassed to the `BinaryOperator<T>` accumulator are of different types, the compiler complains.

## Example

Given a list of bank transactions.

```java
public class Transaction {
  double amount;
}
```

We want to calcuate the sum

```java
List<Transaction> transactions; //...

double sum = transactions.stream()
    .reduce(0.0, (result, t) -> result + t.getAmount(), Double::sum);

```

We have to provide a `Double::sum` combiner parameter for it to compile. Taking a closer look at the API:

```java
<U> U reduce(U identity,
             BiFunction<U,? super T,U> accumulator,
             BinaryOperator<U> combiner)

```

The arguments of our accumulator above has different types which are of `Transaction` and `Double`. Therefore, we need the third combiner.
