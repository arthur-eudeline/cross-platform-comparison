# JSON Generator template

You can use [JSON Generator](https://www.json-generator.com/) website to generate 100 false articles.

```
[
  '{{repeat(100)}}',
  {
    id: '{{objectId(6, "words")}}',
    title: '{{lorem()}}',
    date: '{{date(null,null,"dd/MM/YYYY")}}',
    image: '__URL__',
    description: '{{lorem(4)}}'
  }
]
```