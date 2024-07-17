# map

## EmptyStringIntMap(RunTime)

| Benchmark | Results | Delta |
| --------- | ------- | ----- |
| `LinkedHashMap` | 0.11ms | 16.59% |
| `SplayTreeMap` | 0.13ms | 46.26% |
| `HashMap` | **0.09ms** | +0.00% |
| `IndexMap` | *0.15ms* | -71.16% |

## CreateMapWith1kStringIntEntries(RunTime)

| Benchmark | Results | Delta |
| --------- | ------- | ----- |
| `LinkedHashMap` | *416.88ms* | -104.09% |
| `SplayTreeMap` | 394.78ms | 93.27% |
| `HashMap` | **204.26ms** | +0.00% |
| `IndexMap` | 387.82ms | 89.86% |

## IterateMapWith1kStringIntEntries(RunTime)

| Benchmark | Results | Delta |
| --------- | ------- | ----- |
| `LinkedHashMap` | 204.49ms | 99.69% |
| `SplayTreeMap` | 196.44ms | 91.83% |
| `HashMap` | *238.86ms* | -133.25% |
| `IndexMap` | **102.40ms** | +0.00% |

## Hash1kEntries(RunTime)

| Benchmark | Results | Delta |
| --------- | ------- | ----- |
| `LinkedHashMap` | 241.88ms | 7.46% |
| `SplayTreeMap` | *842.40ms* | -274.26% |
| `HashMap` | **225.08ms** | +0.00% |
| `IndexMap` | 228.53ms | 1.53% |

## RemoveEveryOtherEntry1kEntries(RunTime)

| Benchmark | Results | Delta |
| --------- | ------- | ----- |
| `LinkedHashMap` | 34.47ms | 46.39% |
| `SplayTreeMap` | *312.01ms* | -1225.11% |
| `HashMap` | **23.55ms** | +0.00% |
| `IndexMap` | 24.50ms | 4.07% |
