<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

**Table of Contents** _generated with [DocToc](https://github.com/thlorenz/doctoc)_

- [复式记账](#%E5%A4%8D%E5%BC%8F%E8%AE%B0%E8%B4%A6)
  - [资产 & 净资产](#%E8%B5%84%E4%BA%A7--%E5%87%80%E8%B5%84%E4%BA%A7)
    - [财富自由](#%E8%B4%A2%E5%AF%8C%E8%87%AA%E7%94%B1)
  - [为什么复式记账](#%E4%B8%BA%E4%BB%80%E4%B9%88%E5%A4%8D%E5%BC%8F%E8%AE%B0%E8%B4%A6)
  - [如何复式记账](#%E5%A6%82%E4%BD%95%E5%A4%8D%E5%BC%8F%E8%AE%B0%E8%B4%A6)
  - [Beancount](#beancount)
  - [后续](#%E5%90%8E%E7%BB%AD)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# 复式记账

参考：https://byvoid.com/zhs/blog/beancount-bookkeeping-1/?amp=1

## 资产 & 净资产

### 财富自由

只要在预期的寿命之内资产（而不是净资产）产生现金流能够满足生活所需的开销，这就是财务自由。我对资产产生现金流的定义较为宽泛，不仅包括利息、分红、租金、版税这类收入，还包括了直接通过资产折现的收入，即净资产减少。

1. 支出的预期
2. 资产和收入的了解
3. 寿命的期望

## 为什么复式记账

- 复式记账的核心理念是账户之间的进出关系，要求所有的记录全部入账，它可以保证账目的完整性和一致性
- 复式记账可以提供除了开支记录之外的损益表、资产负债表、现金流量表、试算平衡表等报表。
- 复式记账还可以把投资和消费轻易区分，譬如购入电脑、手机，可以作为资产项目入账并定期折旧。同理对各种代金券、点数积分的购入一样要算入资产而不是消费
- 安全性
- 持久性
- 价值：数据的完整性

## 如何复式记账

会计恒等式

资产 assets = 负债 liability + 权益（净资产）

一个人到底是否富有，看的是净资产，而不是资产。（总资产排除债务）

## Beancount

- 开源 python 项目，可以本地运行
- 账本是一套基于文本的语法

[关于 Chrome 访问本地端口 403](https://www.tortorse.com/archives/996/)得到了解决

## 后续

> 20210101 迁移至 md 文件归档

本地的 beancount 项目 README
