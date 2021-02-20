# SQL 入门笔记

sql 不常用也会忘的，而且高效 sql 有利于生产力提升哦

环境 ubuntu18.04 + MySQL5.7

## 数据库基础

### 数据库的发展历史

### 数据库管理系统

### 数据库系统 DBS

## 关系型数据库

### 基本对象

- 表 table
- 视图 view
- 索引 index

## SQL 数据库

## DDL Data Define Language

### CREATE

- 创建数据库: `create database db_name;`

- 创建表，涉及到字段类型，关于数据表选择的引擎 engine 之后再说:

  - 语法: `create table tb_name(column_name TYPE [], ...);`

    ```mysql
    CREATE TABLE T(
        id INT AUTO INCREMENT PRIMARY KEY,
        gh CHAR(4) PRIMARY KEY,
        xm VARCHAR(4),
        xb ENUM('男', '女') NOT NULL,
        csrq DATE,
        xl VARCHAR(8),
        jbgz FLOAT(10, 2),
        yxh CHAR(2),
        CONSTRAINT fk_t_d FOREIGN KEY (yxh) REFERENCES D(yxh)
    );
    ```

  - 数据类型(主要):

    - char: 定字节长的字符类型
    - varchar: 可变长字符类型，传递最大长度
    - int
    - enum: 枚举类型，指定字符集合
    - float: 浮点类型，第一个参数是总长多少位，第二个是小数部分多少位
    - date: 日期类型，插入的时候可以`'2019,1,1'`或者`'2019-1-1'`
    - datetime: 日期时间类型

  - 修饰主键:

    - 在字段后加上`primary key`
    - 组合主键，用`primary key(k1, k2, k3)`

  - 外键:

    - 如果需要命名 FOREIGN KEY 约束，以及为多个列定义 FOREIGN KEY 约束，请使用下面的 SQL 语法：`CONSTRAINT foreign_preorders FOREIGN KEY (column) REFERENCES table(column)`

  - 自增:`AUTO INCREMENT`，需要字段数据类型是 int，在定义字段的最后修饰就行，默认 1 开始，插入时可以不传入数值，自动会有记录

### DROP 删除数据库以及其中的对象(table, view, index)

- 删除表: `drop table tb_name`
- 删除数据库: `drop database db_name`

### ALTER

- 表中添加列:`alter table tb_name add column_name datatype`
- 删除表中列: `alter table tb_name drop column column_name`

## DML Data Manipulation Language

### SELECT

至关重要

`select column[, column, [column, ...] from table [where condition] [order by column]`

#### GROUP BY

`select [expressions] from table [...] GROUP BY column`

sql 的规范是 group by 后面的列必须在表达式中出现

分组，分的是啥？按照 column 的不同值来分组，每一组对应的表达式的值作为一行，举个例子

```sql
-- 统计每个大类的专业个数
select category_id category, count(category_id) cat_num from major group by category_id;
+----------+---------+
| category | cat_num |
+----------+---------+
|        1 |      11 |
|        2 |      14 |
|        3 |      41 |
+----------+---------+
```

以下例子的表情况:

- 选课表: 学生号 sno, 课程号, 分数

问题中出现"每"这个字眼的时候就要考虑其后面的列需要分组，比如：

- 每门课的学生人数 ==> **group by 课程**
- 选课一门以上的学生学号 ==> **where 课程数>1 group by 学号**
- 统计男女同学人数和平均年龄 ==> **group by 性别**
- 每门课程都超过 70 分的学生学号
- 男女人数统计
- 查询每门课的学生人数和总成绩，结果按照总成绩升序，学号降序

#### Having

这个 having 的出现是因为在 where 语句中不能使用合计函数(aggregate function)，先分组后判断条件用 having

语法:

```sql
SELECT column_name, aggregate_function(column_name)
FROM table_name
WHERE column_name operator value
GROUP BY column_name
HAVING aggregate_function(column_name) operator value
```

要是查询的条件需要用到合计函数，那么就用 having 这个 clause

#### 多表查询

1. 联接操作 将多个表构成一张表

   - 自身连接也就是 inner join 自己和自己

   - 查询选课 2 门或 2 门以上的学生学号 ==> **group by 学号** :

     - 笛卡尔积查询: `select * from sc x, sc y where x.学号 ＝ ｙ.学号 and x.课程 <> y.课程` 现在这个查询结果就由两张一样的表构成的笛卡尔积，然后从这个笛卡尔积结果中搜索满足条件的行。
     -

   - 选修 c1 c2 课程的学生学号，姓名

     - `select from 学生表 s, 选课表 x, 选课表 y where s.sno=x.sno and x.sno=y.sno and x.cno='c1' and y.cno='c2'`

   - 复合连接
     - 选修 m 课的成绩且在 70 分以上的学生
     -

2. 子查询/嵌套查询(in 运算)

   - 查询选了 c2 课程的学生的姓名

     - `select sname from 学生表 where sno in (select sno from 选课表 where 课程号 = 'c2')` select 查询到返回的是一个 set of tuple，用`in`来找出满足条件的学号

   - 查询选了课程名为"database"的学生的姓名(课程名在课 table 中)(三层嵌套)

   - **exists v.s. in**

     - 效果同样是用外层查询的结果逐个在内层查询结果集中比较，找到相同的行

     - **in**: 在`IN()`中的 sql 只会查询一次，结果集会被临时储存起来，再查询外层的 sql，进行匹配

     - **EXISTS**: 会逐个查询外层结果集，将其放入 exists 内部的子查询去查询，如果查询到了就返回 true。

     - 举个例子，user 有 1000 条，order 有 100000000 条:

       ```sql
       SELECT SQL_NO_CACHE * FROM `user` WHERE id IN (SELECT user_id FROM `order`);
       -- 如果是in的话最多会遍历user.length * order.length
       SELECT SQL_NO_CACHE * FROM `user` WHERE EXISTS (SELECT * FROM `order` WHERE `user`.id = `order`.user_id);
       -- 用exists只会遍历user的长度
       ```

     - 结论:

       - 在嵌套**子查询的结果远大于外层查询**的情况下用 in 的效率会比 exists 差很多
       - 子查询数量小于外层的时候，exists 会差。

3. 相关子查询

   - 查询所有选课 c1 的学生的学号，姓名 ==> 用双重否定！ 不存在学生 x 没选课 p 的
     - $(\forall x)p \Rightarrow $
   - 求和学号 s3 的学生选的课一样的学生的学号 s3 上的其他的人也全上
     - 任意的$(\forall x) p \rightarrow q \Rightarrow \lnot (\exists y) \lnot (\lnot p \lor q) \Rightarrow \lnot (\exists y) (p \land \lnot q)$ 其中: p: s3 上了 c，q: sx 上了 c

4. 存在量词的子查询(EXISTS)

#### ORDER BY 排序

根据 column 排序

#### (INNER/LEFT/RIGHT/OUTER/CROSS) JOIN

- inner join 内连接(最常用): 两张表有相同的列名
  - 自己和自己连接

cross join 交叉连接: 两张表完全没有关系，构成笛卡尔积

#### all any some

- ALL: 必须在比较运算符之后出现，e.g.`c > all(subquery)`，参数是子查询的结果，比如在找大于一个集合的值，相当于`c > max(subquery)`

### INSERT

```sql
insert into <table_name>
```

### DELETE FROM(删除表中满足条件的 tuple)

### UPDATE(修改表中的数据)

```sql
update <tbname>
set <column>=<expression>
[, <column>=<expression>, ...]
where clause
```

例子: 将小于 70 分的增加 5%，大于 70 分的增加 5%

注意: 一个列只能被修改一次，所以分数这个字段只能被修改一次。在另一张表中的数据用`in`来嵌套

用两次命令来执行，注意顺序先做大于 70 分的操作。

## view 视图

### view 是什么?

视图是一张虚表，和 table 区分开，不存实际的数据。是从具体的一个或者多个 table 中导出的一张表。

### 语法

```sql
CREATE VIEW view_name[(column, ...)] AS
(
	SELECT columns
    FROM tables
    WHERE conditions
)
-- 也就是创建了一个视图的定义，一种表查询的封装
```

查看视图
`show full tables where table_type='view';`

删除视图

`DROP VIEW IF EXISTS view_name;`

### view 的好处和缺点

#### 好处:

1. 提高重用性，相当于一个函数，需要频繁的获取某些数据的时候可以构建一张 view

   e.g. `select u.name, g.name from user as u, goods as g, user2goods as ug where u.id=ug.user_id and g.id=ug.goods_id;`

   创建视图: `create view ug_name as select u.name, g.name from user as u, goods as g, user2goods as ug where u.id=ug.user_id and g.id=ug.goods_id;`

   创建之后只需要从 ug_name 这个视图(看成是一个新的表(虚表))中查询即可，`select * from other;`

2. 逻辑独立性，对数据库的重构，对原来的程序代码无影响，也就是说，当数据库的结构修改时，不需要去修改业务代码

   e.g. 原始代码是对 user 表的查询，数据库修改之后

3. 安全性，由于视图大部分不能被 update，可以对于不同用户设定不同的 view，使得数据不能被修改，并且可以对用户屏蔽某些字段

4. 数据结构清晰

#### 缺点:

- 性能相对差
- 修改不方便

### view 的更新

很多条件限制了 view 的更新

只有单表 select columns from table，才能 insert，update，delete。相当于转换为对 table 的操作。

可以更新的视图:

- 对单个基本表导出的视图

## 索引 Index

## 嵌入式 sql

即 sql 在主语言中的使用

作业 抄题 编号 22

书 4.2 4.6.4.7 4.9

## 数据库体系结构

ER 图

#### 层次模型(淘汰)

就是一棵树，一个节点只有一个父节点(除了根)

#### 网状模型

图，一个点

#### 关系模型 Relational Database

1970 年提出

#### 面向对象模型

#### 分布式数据库

区块链

### 关系代数的基本运算

回忆一下离散数学中学过的*关系*，如果是二元关系，那就是一个有序对，表示这两个元素是有关系的，那么在数据库中，多个字段的组成的元组可以看成是他们之间有一个整体的关系。每一张表就是关系的集合。

九个常用运算:

$-$(not in),$\or$,

笛卡尔积: $R \times S$，形成一个新的有序元组对$<t_r, t_s>$

投影: 对一个关系垂直分割，消去某些列 (相当于 SELECT)，联想线性代数，这里不能是变换只能是投影，因为没办法升维啊。

选择: 相当于 WHERE，水平分割，选择符合条件的元素构成新的元组

$\and$运算:$A \and B = A - (A - B)$可以通过两次差运算得到，不是基本

联接运算:

- 自然联接: 有相同属性 f，把相同属性的值的行相加，最后去掉重复元素。先笛卡尔积，然后选择(where a.f=b.f)，然后投影(select 去掉重复的属性)。(也就是 INNER JOIN)

$\div$运算: 看成是笛卡尔积的逆运算?$R \div S$是一个(r-s)元的元组的集合，R 的列数要大于 S 的列数：

- 计算方法: 将除之后剩下的列的组合分组，在 R 关系中包含了 S 的全部，那么这一种组合就是结果之一，得到全部的结果。
- 这个运算还挺抽象的，不好理解，在数学中的除法就是得到是除数在被除数中所占的比例，可以看成是除数的某一后验**属性**$Attr(divisor|dividend)$(给定被除数，除数所占其的比例)自创的哈。那么在关系运算中，R 中的列必须包含一个或多个 S 中的列，
- 方法:[来自 csdn](https://blog.csdn.net/u012411414/article/details/41048861)这篇我看懂了，但是遇到 R 中不同的列有多个的时候，要用上面说的多个组合的像集

扩充的关系代数操作:

- 外联接(左，右 left/right join):在自然联接的基础上把其他列的元组加入，如果另一张表(左/右)中没有则为 null
- 外并
- 半联接

### 关系代数表达式的优化

想要时间空间的效率高，就要去优化他，所有东西到最后都是优化问题...

等价关系: 表达式的最终结果是相同的

怎么去优化，希望实现得到的最终结果的过程是最优的，解空间就是表达式集合。

时间空间: 表的大小，列的数量。

等价变换规则

优化的策略: 选择操作尽量放在笛卡尔积之前，**主要思想:让多表查询的中间表结果变小**

语法树:

- 类似数据结构学的将数学表达式用树的形式表现，**注意语法树中没有自然联接，只有笛卡尔积**
- 优化策略:
  - 将选择$\sigma$操作尽量往叶子节点靠
  - 投影$\Pi$在选择之前的时候，把投影增加一个在选择之下(树的角度)和笛卡尔积之上，然后将投影往叶子节点靠，投影之后的笛卡尔积列数会少，这样笛卡尔积结果会变小。
- 优化的结果(似乎有规律):
  - 树上的节点都是**表->选择->投影**，三个操作看成是一个组合，就是一颗**二叉树！递归来做！**
- 核心思路:
  - 叶节点的表在做笛卡尔积之前就最好经过先投影再选择的降维操作，减少笛卡尔积之后的标的大小。
  - 表节点前缺少投影的时候利用选择操作的父节点的投影的覆盖性(?)在表节点前增加投影，并且递归的让投影往每个叶节点去。
  - 最终能先选择的就先选择，再投影，最后笛卡尔积
