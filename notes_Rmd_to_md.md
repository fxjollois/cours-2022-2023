# Rmd to md pour les slides

Option `YAML` à mettre dans le fichier `.Rmd`

```
---
output: 
  md_document:
    variant: markdown_github
    include: 
      in_header: test_md_document_header.md
---
```

Fichier `test_md_document_header.md` 

```
---
layout: slides
---
```
