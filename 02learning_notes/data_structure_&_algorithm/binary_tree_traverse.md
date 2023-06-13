# 二叉树遍历

    介绍常规的三种递归遍历方法（先中后）以及非递归的先序、中序、后序、层序遍历

## Prerequisite

对二叉树这种数据结构有一定了解<br>遍历二叉树的目的是为了访问到每个结点且按照某一特定的顺序

![二叉树](https://gss0.baidu.com/-fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/f31fbe096b63f624b5f16b378544ebf81a4ca352.jpg "二叉树")

## 先序遍历

### 1.遍历顺序

**一定要记住** 子树的**根**->**左**->**右**

### 2.递归遍历

递归的特点就是代码可读性高，容易理解

```
/*先序遍历，以rt为根的树*/ //根->左->右
template <class T>
void BinaryTree<T>::PreOrder(const Node* rt, void(*Visit)(const T&)) const {
	if (rt != nullptr) {
		(*Visit)(rt->data);
		PreOrder(rt->left_child, Visit);
		PreOrder(rt->right_child, Visit);
	}
}
```

### 3.非递归遍历

先分析先序遍历效果：如上图先序遍历的顺序为**ABCDEFGHK**。<br>根总是先被访问，之后被访问的就是他的左孩子，左孩子又称为新的根，于是继续访问他的左孩子，直到这个根没有左孩子，之后访问他的右儿子，如果他没有右儿子，如图中的**D** ，追溯到他的父节点去访问右儿子，一直追溯，直到有了右儿子，如**E**是**A**的右儿子， **E**又作为新的根节点先被访问 ，继续一开始的遍历。<br>可能要被我绕晕了，简言之，得到根节点之后先对其访问，然后要访问全部的左儿子，最后再是右儿子。所以，一颗子树的右儿子要放在最后访问，就好比压在最下面，等上面的根和左儿子访问过了在出来，于是，这里我们用到了 **栈** 。
上代码！

```
/*非递归先序遍历*/
template <class T>
void BinaryTree<T>::NoRecurringPreOrder(const Node* rt, void(*Visit)(const T&)) const {
	if (rt == nullptr) {
		return;
	}
	stack<Node*> s;
	Node* temp = nullptr;
	s.push(rt);
	while (s.empty() == false) {
		temp = s.top();
		s.pop();
		(*Visit)(temp->data);
		if (temp->right_child != nullptr) {		//右节点后访问，先压入栈
			s.push(temp->right_child);
		}
		if (temp->left_child != nullptr) {
			s.push(temp->left_child);
		}
	}
}
```

## 中序遍历

### 1.遍历顺序

子树的**左**->**根**->**右**

### 2.递归遍历

代码：

```
/*中序遍历*/   //左->根->右
template <class T>
void BinaryTree<T>::InOrder(const Node* rt, void(*Visit)(const T&)) const {
	if (rt != nullptr) {
		InOrder(rt->left_child, Visit);
		(*Visit)(rt->data);
		InOrder(rt->right_child, Visit);
	}
}
```

### 3.非递归遍历

遍历效果：上图遍历顺序为**BDCAEHGKF**<br>
遍历思路：一路向左！直到这个左孩子作为根的时候没有它自己的左孩子，那就先访问他，因为此时按照遍历顺序**左**->**根**->**右**，他被当成根了（没有左孩子），访问他完之后就取访问他的右儿子，继续一路向左，重复过程...<br>
伪代码：当前根不为空的时候=>压入=>他成为他的左儿子=>循环，如果当前是空=>取栈顶（当前根）访问他，并且 pop()=>他成为他的右儿子=>循环，栈空或者最初根为 nullptr 的时候退出。
<br>上代码:

```
/*非递归中序遍历*/
template <class T>
void BinaryTree<T>::NoRecurringInOrder(Node* rt, void(*Visit)(const T&)) const {
	Node* temp = rt;
	stack<Node*> s;
	while (temp || s.empty() == false) {
		if (temp) {
			s.push(temp);
			temp = temp->left_child;
		}
		else {						//没有左孩子了，就取当前栈顶（是上一个根的左孩子）访问，并pop
			temp = s.top();
			s.pop();
			(*Visit)(temp->data);
			temp = temp->right_child;
		}
	}
}
```

## 后序遍历

### 1.遍历顺序

子树的**左**->**右**->**根**

### 2.递归遍历

代码：

```
/*后序遍历*/ //左->右->根
template <class T>
void BinaryTree<T>::PostOrder(const Node* rt, void(*Visit)(const T&)) const {
	if (rt) {
		PostOrder(rt->left_child, Visit);
		PostOrder(rt->right_child, Visit);
		(*Visit)(rt->data);
	}
}
```

### 3.非递归遍历

遍历效果：**DCBHKGFEA**

#### 关于思路

后序遍历的非递归就比前两种的要复杂一点了，也比较难理解，因为根是最后被访问的，而在栈顶的元素当做根的话并不知道他的儿子们有没有被访问过，所以开一个栈不够，起码还要一个栈来保存一个标记，这个标记用来记录他的儿子们有没有被访问过。

#### 关于方法

方法有很多种，可以开一个布尔栈放入对应根节点的标记，判断当前根已经被访问过儿子们了即可出栈，否则就压入他的两个儿子（按顺序是先左后右，又因为栈的关系，所以先压入右儿子）。
<br>这里呢我就介绍一种方法：开一个栈，每次节点压入都压两次，出栈的时候判断栈顶元素是否和他相同，如果两个相同，就说明他的儿子没有被访问（压入栈），就先压入他的右孩子，再左孩子，注意**每次压入都是压两个**，空节点不入栈。

代码：

```
/*非递归后序遍历*/
void BinaryTree<T>::NoRecurringPostOrder(Node* rt, void(*Visit)(const T&)) const {
	if (rt == nullptr) {
		return;
	}
	stack<Node*> s;
	Node* temp = rt;
	s.push(temp);
	s.push(temp);
	while (s.empty() == false) {
		temp = s.top();
		s.pop();
		if (!s.empty() && temp == s.top()) {//栈空了就只剩最后一个，直接访问
			if (temp->right_child) {		//先压入右孩子
				s.push(temp->right_child);
				s.push(temp->right_child);
			}
			if (temp->left_child) {
				s.push(temp->left_child);
				s.push(temp->left_child);
			}
		}
		else {
			(*Visit)(temp->data);
		}
	}
}

```

目前我看到的方法不管是开两个栈还是一个栈，需要的空间都是总节点数的两倍。

## 层序遍历

### 1.遍历顺序

按照层数从左往右依次遍历
<br>上图遍历效果:**ABECFDGHK**

### 2.利用队列层序遍历

思路：访问的顺序像排队一样逐层遍历，每层的下面一层，按照从左到右的顺序在当前层的最后排好队，当前层也是按照从左往右的顺序被排好了，那在访问当前层的节点时将儿子们（下一层）排入尾，这样就可以实现了。_可以看成是一种递推，把根看成最初的一个人在排队_
<br>上代码:

```
/*层序遍历，利用队列，也可以利用数组，然后用两个指针去控制入和出*/
template <class T>
void BinaryTree<T>::LevelOrder(Node* rt, void(*Visit)(const T&)) const {
	queue<Node*> q;
	Node* temp;
	if (rt != nullptr) {
		q.push(rt);
	}
	while (!q.empty()) {
		temp = q.front();
		q.pop();		//pop的位置？
		(*Visit)(temp->data);
		if (temp->left_child) {
			q.push(temp->left_child);
		}
		if (temp->right_child) {
			q.push(temp->right_child);
		}
	}
}
```

### 3.利用数组实现

还有一种利用数组来实现的方法，网上找到的，大致思路其实就是用数组实现了队列的功能：通过两个指针 in out（都是下标）控制，个人认为会浪费资源空间，不过思路很好。

```
void FloorPrint(pTreeNode Tree)  //层序遍历
{
	pTreeNode temp[100];   //创建pTreeNode指针类型的指针数组
	int in = 0;
	int out = 0;

	temp[in++] = Tree;  //先保存二叉树根节点

	while (in > out)
	{
		if (temp[out])
		{
			cout << temp[out]->data << " → ";
			temp[in++] = temp[out]->leftPtr;
			temp[in++] = temp[out]->rightPtr;
		}
		out++;
	}
}
作者：askunix_hjh
来源：CSDN
原文：https://blog.csdn.net/m0_37925202/article/details/80796010
版权声明：本文为博主原创文章，转载请附上博文链接！
```

## 小结

二叉树的遍历很重要（我们老师是这么说的。。可能只是为了应付考试吧）我还是比较推荐在理解的基础上掌握知识，要不断的在脑海中模拟遍历的过程，递归的和非递归的。
