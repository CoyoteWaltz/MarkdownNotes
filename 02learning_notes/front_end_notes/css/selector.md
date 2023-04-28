### 选择器

[W3C](https://www.w3school.com.cn/cssref/css_selectors.asp)

| 选择器                                                                                             | 例子                  | 例子描述                                               | CSS |
| :------------------------------------------------------------------------------------------------- | :-------------------- | :----------------------------------------------------- | --- |
| [._class_](https://www.w3school.com.cn/cssref/selector_class.asp)                                  | .intro                | 选择 class="intro" 的所有元素。                        | 1   |
| [#_id_](https://www.w3school.com.cn/cssref/selector_id.asp)                                        | #firstname            | 选择 id="firstname" 的所有元素。                       | 1   |
| [\*](https://www.w3school.com.cn/cssref/selector_all.asp)                                          | \*                    | 选择所有元素。                                         | 2   |
| [_element_](https://www.w3school.com.cn/cssref/selector_element.asp)                               | p                     | 选择所有 <p> 元素。                                    | 1   |
| [_element_,_element_](https://www.w3school.com.cn/cssref/selector_element_comma.asp)               | div,p                 | 选择所有 <div> 元素和所有 <p> 元素。                   | 1   |
| [_element_ _element_](https://www.w3school.com.cn/cssref/selector_element_element.asp)             | div p                 | 选择 <div> 元素**内部的所有** <p> 元素。               | 1   |
| [_element_>_element_](https://www.w3school.com.cn/cssref/selector_element_gt.asp)                  | div>p                 | 选择**父元素**为 <div> 元素的所有 <p> 元素。           | 2   |
| [_element_+_element_](https://www.w3school.com.cn/cssref/selector_element_plus.asp)                | div+p                 | **选择紧接在** <div> 元素之后的**一个相邻** <p> 元素。 | 2   |
| [[_attribute_\]](https://www.w3school.com.cn/cssref/selector_attribute.asp)                        | [target]              | 选择带有 target 属性所有元素。                         | 2   |
| [[_attribute_=_value_\]](https://www.w3school.com.cn/cssref/selector_attribute_value.asp)          | [target=_blank]       | 选择 target="\_blank" 的所有元素。                     | 2   |
| [[_attribute_~=_value_\]](https://www.w3school.com.cn/cssref/selector_attribute_value_contain.asp) | [title~=flower]       | 选择 title 属性包含单词 "flower" 的所有元素。          | 2   |
| [[_attribute_\|=_value_\]](https://www.w3school.com.cn/cssref/selector_attribute_value_start.asp)  | [lang\|=en]           | 选择 lang 属性值以 "en" 开头的所有元素。               | 2   |
| [:link](https://www.w3school.com.cn/cssref/selector_link.asp)                                      | a:link                | 选择所有未被访问的链接。                               | 1   |
| [:visited](https://www.w3school.com.cn/cssref/selector_visited.asp)                                | a:visited             | 选择所有已被访问的链接。                               | 1   |
| [:active](https://www.w3school.com.cn/cssref/selector_active.asp)                                  | a:active              | 选择活动链接。mouse down                               | 1   |
| [:hover](https://www.w3school.com.cn/cssref/selector_hover.asp)                                    | a:hover               | 选择鼠标指针位于其上的链接。                           | 1   |
| [:focus](https://www.w3school.com.cn/cssref/selector_focus.asp)                                    | input:focus           | 选择获得焦点的 input 元素。                            | 2   |
| [:first-letter](https://www.w3school.com.cn/cssref/selector_first-letter.asp)                      | p:first-letter        | 选择每个 <p> 元素的首字母。                            | 1   |
| [:first-line](https://www.w3school.com.cn/cssref/selector_first-line.asp)                          | p:first-line          | 选择每个 <p> 元素的首行。                              | 1   |
| [:first-child](https://www.w3school.com.cn/cssref/selector_first-child.asp)                        | p:first-child         | 选择属于父元素的第一个子元素的每个 <p> 元素。          | 2   |
| [:before](https://www.w3school.com.cn/cssref/selector_before.asp)                                  | p:before              | 在每个 <p> 元素的内容之前插入内容。                    | 2   |
| [:after](https://www.w3school.com.cn/cssref/selector_after.asp)                                    | p:after               | 在每个 <p> 元素的内容之后插入内容。                    | 2   |
| [:lang(_language_)](https://www.w3school.com.cn/cssref/selector_lang.asp)                          | p:lang(it)            | 选择带有以 "it" 开头的 lang 属性值的每个 <p> 元素。    | 2   |
| [_element1_~_element2_](https://www.w3school.com.cn/cssref/selector_gen_sibling.asp)               | p~ul                  | 选择相同父元素，位于 <p> 元素的每个 <ul> 元素。        | 3   |
| [[_attribute_^=_value_\]](https://www.w3school.com.cn/cssref/selector_attr_begin.asp)              | a[src^="https"]       | 选择其 src 属性值以 "https" 开头的每个 <a> 元素。      | 3   |
| [[_attribute_\$=_value_\]](https://www.w3school.com.cn/cssref/selector_attr_end.asp)               | a[src$=".pdf"]        | 选择其 src 属性以 ".pdf" 结尾的所有 <a> 元素。         | 3   |
| [[*attribute\*\*=*value\*\]](https://www.w3school.com.cn/cssref/selector_attr_contain.asp)         | a[src*="abc"]         | 选择其 src 属性中包含 "abc" 子串的每个 <a> 元素。      | 3   |
| [:first-of-type](https://www.w3school.com.cn/cssref/selector_first-of-type.asp)                    | p:first-of-type       | 选择属于其父元素的首个 <p> 元素的每个 <p> 元素。       | 3   |
| [:last-of-type](https://www.w3school.com.cn/cssref/selector_last-of-type.asp)                      | p:last-of-type        | 选择属于其父元素的最后 <p> 元素的每个 <p> 元素。       | 3   |
| [:only-of-type](https://www.w3school.com.cn/cssref/selector_only-of-type.asp)                      | p:only-of-type        | 选择属于其父元素唯一的 <p> 元素的每个 <p> 元素。       | 3   |
| [:only-child](https://www.w3school.com.cn/cssref/selector_only-child.asp)                          | p:only-child          | 选择属于其父元素的唯一子元素的每个 <p> 元素。          | 3   |
| [:nth-child(_n_)](https://www.w3school.com.cn/cssref/selector_nth-child.asp)                       | p:nth-child(2)        | 选择属于其父元素的第二个子元素的每个 <p> 元素。        | 3   |
| [:nth-last-child(_n_)](https://www.w3school.com.cn/cssref/selector_nth-last-child.asp)             | p:nth-last-child(2)   | 同上，从最后一个子元素开始计数。                       | 3   |
| [:nth-of-type(_n_)](https://www.w3school.com.cn/cssref/selector_nth-of-type.asp)                   | p:nth-of-type(2)      | 选择属于其父元素第二个 <p> 元素的每个 <p> 元素。       | 3   |
| [:nth-last-of-type(_n_)](https://www.w3school.com.cn/cssref/selector_nth-last-of-type.asp)         | p:nth-last-of-type(2) | 同上，但是从最后一个子元素开始计数。                   | 3   |
| [:last-child](https://www.w3school.com.cn/cssref/selector_last-child.asp)                          | p:last-child          | 选择属于其父元素最后一个子元素每个 <p> 元素。          | 3   |
| [:root](https://www.w3school.com.cn/cssref/selector_root.asp)                                      | :root                 | 选择文档的根元素。                                     | 3   |
| [:empty](https://www.w3school.com.cn/cssref/selector_empty.asp)                                    | p:empty               | 选择没有子元素的每个 <p> 元素（包括文本节点）。        | 3   |
| [:target](https://www.w3school.com.cn/cssref/selector_target.asp)                                  | #news:target          | 选择当前活动的 #news 元素。                            | 3   |
| [:enabled](https://www.w3school.com.cn/cssref/selector_enabled.asp)                                | input:enabled         | 选择每个启用的 <input> 元素。                          | 3   |
| [:disabled](https://www.w3school.com.cn/cssref/selector_disabled.asp)                              | input:disabled        | 选择每个禁用的 <input> 元素                            | 3   |
| [:checked](https://www.w3school.com.cn/cssref/selector_checked.asp)                                | input:checked         | 选择每个被选中的 <input> 元素。                        | 3   |
| [:not(_selector_)](https://www.w3school.com.cn/cssref/selector_not.asp)                            | :not(p)               | 选择非 <p> 元素的每个元素。                            | 3   |
|                                                                                                    | :not(picture \*)      | 选择不在 picture 为父元素的元素。                      |     |
| [::selection](https://www.w3school.com.cn/cssref/selector_selection.asp)                           | ::selection           | 选择被用户选取的元素部分。                             | 3   |
