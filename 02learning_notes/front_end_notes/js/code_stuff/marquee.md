无限轮播跑马灯，支持多行，每行之间支持偏移量和速度偏移

```tsx
import React, { useMemo, useRef } from "react";
import { useMemoizedFn, useUnmount } from "ahooks";
import styles from "./index.module.scss";
import { animate, linear } from "popmotion";
import Styler from "stylefire";

export interface MarqueeCardProps<Node, Key extends string | number> {
  items: { node: Node; key?: Key }[];
  rowGapPx?: number;
  renderCell?: (item: { node: Node; key?: Key }) => React.ReactNode;
  rows?: number;
  getRowOffsetX?: (rowIndex: number) => number | void;
  getRowOffsetSpeed?: (rowIndex: number) => number | void;
  speedPxPerSecond?: number;
  startOnPromise?: Promise<unknown>;
}

const MarqueeCard: <Node, Key extends string | number>(
  props: MarqueeCardProps<Node, Key>
) => JSX.Element = (props) => {
  const {
    items,
    startOnPromise,
    rows,
    speedPxPerSecond,
    rowGapPx,
    getRowOffsetX,
    getRowOffsetSpeed,
    renderCell,
  } = props;

  const animationStopsRef = useRef<Record<number, (() => unknown)[]>>({});

  useUnmount(() => {
    Object.values(animationStopsRef.current).forEach((fns) =>
      fns?.forEach?.((f) => f?.())
    );
  });

  // 按照每一行去分摊
  const chunkedRows = useMemo(() => {
    const sizePerRow = rows ? Math.floor(items.length / rows) : 0;

    return Array.from({ length: rows || 0 }, (_, idx) => {
      const start = idx * sizePerRow;
      // 最后一行 全部塞入
      const end =
        idx === (rows || 0) - 1 ? items.length : (idx + 1) * sizePerRow;
      const rowItems = items.slice(start, end);
      return rowItems;
    });
  }, [items, rows]);

  const getRowOffsetXOfIndex = useMemoizedFn((rowIndex: number) => {
    const offset = getRowOffsetX?.(rowIndex);
    if (!offset) {
      return 0;
    }
    const rowOffsetX = -1 * Math.abs(offset);
    return rowOffsetX;
  });

  const handleRowMounted = useMemoizedFn(
    (ref: HTMLDivElement | null, rowIndex: number) => {
      Promise.resolve(startOnPromise).then(() => {
        const rowOffsetX = getRowOffsetXOfIndex(rowIndex);
        const rowLen = rowOffsetX ? 3 : 2;

        if (!ref || animationStopsRef.current?.[rowIndex]?.length >= rowLen) {
          return;
        }
        const styler = Styler(ref);
        const finalSpeed =
          (speedPxPerSecond || 0) + (getRowOffsetSpeed?.(rowIndex) || 0);
        const animationTime = ref.scrollWidth / finalSpeed;

        const { stop } = animate({
          from: 0,
          to: 100,
          duration: animationTime * 1000,
          ease: linear,
          repeat: Infinity,
          onUpdate: (latest) =>
            styler.set("transform", `translateX(-${latest}%)`),
        });
        if (animationStopsRef.current[rowIndex]) {
          animationStopsRef.current[rowIndex].push(stop);
        } else {
          animationStopsRef.current[rowIndex] = [stop];
        }
      });
    }
  );

  return (
    <div className={styles["marquee-card"]}>
      {chunkedRows.map((row, rowIndex) => {
        const rowOffsetX = getRowOffsetXOfIndex(rowIndex);

        const rowEls = (
          <div
            className={styles.content}
            ref={(r) => handleRowMounted(r, rowIndex)}
          >
            {row.map((item, idx) => {
              const el =
                typeof renderCell === "function" ? renderCell(item) : item.node;
              return (
                <React.Fragment key={item?.key ?? idx}>{el}</React.Fragment>
              );
            })}
          </div>
        );

        return (
          <div key={rowIndex} className={styles.row}>
            <div
              className={styles.offset}
              style={{
                ...(rowOffsetX
                  ? {
                      transform: `translateX(${rowOffsetX}px)`,
                    }
                  : null),
                ...(rowGapPx && rowIndex >= 1
                  ? {
                      marginTop: `${rowGapPx}px`,
                    }
                  : null),
              }}
            >
              {/* 需要两个完成无限轮播 */}
              {rowEls}
              {rowEls}
              {/* offset 场景需要后面再补一个 防止漏出 */}
              {rowOffsetX ? rowEls : null}
            </div>
          </div>
        );
      })}
    </div>
  );
};

export default MarqueeCard;
```

```scss
.marquee-card {
  width: 100%;
  overflow: hidden;

  .row {
    box-sizing: border-box;
    position: relative;

    .cell {
      flex-shrink: 0;
      padding: 4px;
      background-color: #de5050;
      margin-right: 8px;
    }

    .content {
      box-sizing: border-box;
      position: relative;
      display: flex;
      flex-shrink: 0;
      min-width: 100%;
      will-change: auto;
      transform: translateZ(0);
    }

    .offset {
      box-sizing: border-box;
      display: flex;
      overflow: visible;
      width: 100%;
      position: relative;
      left: 0;
      top: 0;
    }
  }
}
```
