# Narrow Types

> Refs:
>
> - https://formidable.com/blog/2022/narrowing-types/
> - https://www.typescriptlang.org/docs/handbook/2/narrowing.html

## Why Narrow Types

When encountering some _union types_ `'a' | 'b' | { c: '3'}`, we need to do sth with one specific type.

## How

### `if` or `switch`

TS compiler is smart enough to narrow down union types through `if` or `switch`

_Notice: when in the default case and all types was cased, the type would be `never`_

### Using typeof

Use `typeof` to tell TS type.

### `instanceof` or `in`

```typescript
type Movie = {
  title: string;
  releaseDate: Date | string;
  runtime: number;
};

type Show = {
  name: string;
  episodes: {
    releaseDate: Date | string;
    title: string;
    runtime: number;
  }[];
};

function getDuration(media: Movie | Show) {
  if ("runtime" in media) {
    return media.runtime;
  } else {
    return media.episodes.reduce((sum, { runtime }) => sum + runtime, 0);
  }
}

function getPremiereYear(media: Movie | Show) {
  const releaseDate =
    "releaseDate" in media ? media.releaseDate : media.episodes[0].releaseDate;

  if (releaseDate instanceof Date) {
    // detect an instance of Date
    return releaseDate.getFullYear();
  } else {
    return new Date(releaseDate).getFullYear();
  }
}
```

### Predict type

```typescript
function isValidFood(food: string | null): food is string {
  return food !== null;
}
```

Use utility types `NonNullable`

```typescript
const isNotNullish = <T>(value: T): value is NonNullable<T> => value != null;
```

### Truthiness narrowing

When narrowing/excluding falsy type, just tell TS the truth case.

Use `&&`, `||`, `!`, ...

### Exclude

Once I use `Exclude` to narrow a specific type. Nice.
