# Activating theme

1. Add the `beamercolorthemedracula.sty` file to your projects root directory 
2. Add `\usecolortheme{dracula}` to your preamble
3. If you are using beamer with R Markdown , add `colortheme: "dracula"` to YAML header
   
```yaml
---
title: "A Dracula Theme for Beamer Presentation"
subtitle: "Using R Markdown"
author: |
   | Your Name (Msc) 
   | example@gmail.com
institute: "Your instiution Name"
date: "1/16/2021"
output: 
  beamer_presentation:
    theme: "default"
    colortheme: "dracula"
---
```
