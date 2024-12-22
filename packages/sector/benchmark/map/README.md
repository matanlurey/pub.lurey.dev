# map

## EmptyStringIntMap(RunTime)

| Benchmark | Results | Delta |
| --------- | ------- | ----- |
| `LinkedHashMap` | 0.11ms | 18.07% |
| `SplayTreeMap` | 0.13ms | 45.77% |
| `HashMap` | **0.09ms** | +0.00% |
| `IndexMap` | *0.16ms* | -73.64% |

## CreateMapWith1kStringIntEntries(RunTime)

| Benchmark | Results | Delta |
| --------- | ------- | ----- |
| `LinkedHashMap` | *427.34ms* | -114.27% |
| `SplayTreeMap` | 392.04ms | 96.56% |
| `HashMap` | **199.44ms** | +0.00% |
| `IndexMap` | 401.21ms | 101.16% |

## IterateMapWith1kStringIntEntries(RunTime)

| Benchmark | Results | Delta |
| --------- | ------- | ----- |
| `LinkedHashMap` | 207.82ms | 102.35% |
| `SplayTreeMap` | 206.20ms | 100.78% |
| `HashMap` | *245.73ms* | -139.27% |
| `IndexMap` | **102.70ms** | +0.00% |

## Hash1kEntries(RunTime)

| Benchmark | Results | Delta |
| --------- | ------- | ----- |
| `LinkedHashMap` | 246.58ms | 7.71% |
| `SplayTreeMap` | *852.19ms* | -272.26% |
| `HashMap` | **228.92ms** | +0.00% |
| `IndexMap` | 229.32ms | 0.17% |

## RemoveEveryOtherEntry1kEntries(RunTime)

| Benchmark | Results | Delta |
| --------- | ------- | ----- |
| `LinkedHashMap` | 35.01ms | 45.52% |
| `SplayTreeMap` | *312.40ms* | -1198.60% |
| `HashMap` | **24.06ms** | +0.00% |
| `IndexMap` | 38.76ms | 61.11% |
