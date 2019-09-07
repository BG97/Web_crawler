library(stringr)
library("pacman")
library(rvest)
web<-'https://hereditasjournal.biomedcentral.com/'
Link<-web%>%read_html()%>%html_nodes(".c-content-layout--landing , .cms-collection__column-inner > .cms-collection , a")%>%html_text()
dir.create("Articles")

pg<-read_html(web)
Links<-html_attr(html_nodes(pg, "a"), "href")

link<-vector()
num=1
for(i in 1:length(Links)){
  link<-c(link,grep("articles/10",Links[i], value = TRUE))
}
for (i in 1:length(link)){
  if (!startsWith(link[i],'http')){
    link[i]=paste("https://hereditasjournal.biomedcentral.com",link[i],sep="")
  }
}

for (i in 1:length(link)){
  download.file(link[i],paste0("Articles/10.1186_",basename(paste0(link[i],'.html'))))
}
