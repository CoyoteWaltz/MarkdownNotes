# 快速排序

核心思想：每一趟确定一个元素在数组中的位置，然后以这个位置划分子区域去递归

```c++
// low 和 height 为可迭代位置
template <class T>
void my_quick_sort(T* arr, const size_t low, const size_t height)
{
    T pivot = arr[low];
    int i = low, j = height;    //两个游标分别从前、后往中间找
    while (i < j) {
        // 从左往右找比 pivot 小的
        for (; i < j && arr[j] >= pivot; --j);
        //放入前面
        if (i < j) {
            arr[i++] = arr[j];
        }
        // 从右往左找比pivot大的放
        for (; i < j && arr[i] <= pivot; ++i);
        if (i < j) {
            arr[j--] = arr[i];
        }
    }
    arr[i] = pivot;     //确定位置
    // 根据i分为两个子表 这两个字表都需要分治去排序，
    // 但是可能当前pivot的位置是表头或者表尾，那只有一个子表了
    if (i < height - 1) {      // 不在队首
        my_quick_sort(arr, i + 1, height);
    }
    if (i > low + 1) {
        my_quick_sort(arr, low, i - 1);
    }
}
```
