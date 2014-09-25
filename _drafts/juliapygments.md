---
layout: post
---

# Just trying to highlight some code snippets #

{% highlight julia %}
using DataFrames, RDatasets

iris = dataset("datasets","iris")
mean(iris[:PetalLength])
{% endhighlight %}
