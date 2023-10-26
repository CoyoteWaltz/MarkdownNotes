# 域名相关

## 购买域名

选用了 namecheap 这个大公司（[知乎](https://zhuanlan.zhihu.com/p/328501036)上也看到另一个 GoDaddy）

1. 搜索自己想要的顶级域名
2. 下单购买
3. 购买 SSL
4. 在 Dashboard 管理自己的域名

## 设置 subdomain

直接看 namecheap 的[官方教程](https://www.namecheap.com/support/knowledgebase/article.aspx/9776/2237/how-to-create-a-subdomain-for-my-domain/#cname)

## 配置站点的 SSL(HTTPS)

1. 购买 SSL，然后在 Dashboard 中找到 SSL Certificates，选择激活
2. 根据[官方教程](https://www.namecheap.com/support/knowledgebase/article.aspx/794/67/how-do-i-activate-an-ssl-certificate/)，先生成 [CSR](https://www.namecheap.com/support/knowledgebase/article.aspx/467/14/how-to-generate-csr-certificate-signing-request-code/)，我直接选的 [Nodejs](https://www.namecheap.com/support/knowledgebase/article.aspx/9704/2290/generating-a-csr-on-nodejs/) 方法，然后发现其中的 **_openssl_** 指令系统里也有（`which openssl` 查）
3. 生成的 CSR 在电脑里保存好，同时按照教程复制到 namecheap 最后提交表单
4. 选择 CNAME Record 的方式完成 DCV
5. 然后根据[教程](https://www.namecheap.com/support/knowledgebase/article.aspx/9646/2237/how-to-create-a-cname-record-for-your-domain/)新建 CNAME Record，并查询是否有 DNS Record
6. 等待 SSL 证书发放... 未完待续

## 将域名指向 Vercel 的项目

指路参考 dou 的[教程](https://jackeydou.libertylab.icu/post/22-12-16-vercel-domain-setting)

1. 在 vercel 的项目里配置域名，会检查是否生效，如果报错会给出需要配置的 CNAME
2. namecheap 的域名管理的 Advanced DNS 新增 subdomain 即可
