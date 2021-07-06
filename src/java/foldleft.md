# `foldLeft` in Java

  In Java, you can use the [Collector](https://docs.oracle.com/javase/8/docs/api/java/util/stream/Collector.html) interface to perform *reduction* operations on a collection, which is similar to the `foldLeft` function in Scala.

```java
static <T,R> Collector<T,R,R> of(Supplier<R> supplier,
                                 BiConsumer<R,T> accumulator,
                                 BinaryOperator<R> combiner,
                                 Collector.Characteristics... characteristics)
```

## Example

Given an example that one customer has multiple bank accounts:

```java
public class BankAccount {
    String customerName;
    double balance;

    // getter, setters..
}

```
We want to group a list of bank accounts by customer name and find out the balance across the customers' bank accoutns.

```java
List<BankAccount> bankAccounts; //...

Map<String, Double> customers = bankAccounts.stream()
    .collect(Collector.of(
        (Supplier<HashMap<String, Double>>) HashMap::new,
        (result, bankAccount) -> {
            var sum = result.getOrDefault(bankAccount.getCustomerName(), 0.0);
            result.put(b.getCustomerName(), sum + bankAccount.getBalance());
        },
        (a, b) -> a
    ));

```

This can also be addressed by using Java built-in [groupingBy](https://docs.oracle.com/javase/8/docs/api/java/util/stream/Collectors.html#groupingBy-java.util.function.Function-java.util.stream.Collector-) collector:

```java
bankAccounts.stream()
    .collect(Collectors.groupingBy(BankAccount::getCustomerName,
        Collectors.summingDouble(BankAccount::getBalance)));

```
