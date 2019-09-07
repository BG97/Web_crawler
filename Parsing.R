
#analysing
p_load("XML","RCurl")
result = data.frame(matrix(ncol = 10, nrow = 0))


colnames(result) = c("DOI","Title","Authors","AuthorAffiliations",
                     "CorrespondingAuthor","CorrespondingAuthorEmail",
                     "PublicationDate","Abstract","Keywords","FullText")


files <- list.files(path="Articles", pattern="*.html", full.names=TRUE, recursive=FALSE)

for (i in 1:length(files)){
  #DOI
  DOI<-files[i]%>%read_html()%>%html_nodes(".u-text-inherit")%>%html_text()
  
  #TITLE
  Title <- files[i]%>%read_html()%>%html_nodes("  .ArticleTitle ")%>%html_text()
  if (Title==""){Title = NA}
  
  #Authors
  Authors <- files[i]%>%read_html()%>%html_nodes("  .AuthorName ")%>%html_text()
  Authors = paste(Authors, collapse = ', ')
  if (Authors==""){Authors = NA}
  
  #AuthorAffiliations
  AuthorAffiliations <- files[i]%>%read_html()%>%html_nodes("  .hasAffil~ .hasAffil+ .hasAffil .AuthorName , .hasAffil:nth-child(1) .AuthorName ")%>%html_text()
  AuthorAffiliations = paste(AuthorAffiliations, collapse = ', ')
  if (AuthorAffiliations==""){AuthorAffiliations = NA}
  
  #CorrespondingAuthor
  CorrespondingAuthor <- files[i]%>%read_html()%>%html_nodes("  .AuthorName ")%>%html_text()
  CorrespondingAuthor = tail(CorrespondingAuthor, n=1)
  if (CorrespondingAuthor==""){CorrespondingAuthor = NA}
  
  #CorrespondingAuthorEmail
  CorrespondingAuthorEmail <- files[i]%>%read_html()%>%html_nodes("  a.EmailAuthor ")%>%html_attr("href")
  CorrespondingAuthorEmail = sub("mailto:","",CorrespondingAuthorEmail)
  CorrespondingAuthorEmail = paste(CorrespondingAuthorEmail, collapse=',')
  if (CorrespondingAuthorEmail==""){CorrespondingAuthorEmail = NA}
  
  #PublicationDate
  PublicationDate <- files[i]%>%read_html()%>%html_nodes("  li.History.HistoryOnlineDate ")%>%html_text()
  PublicationDate = sub("Published: ","",PublicationDate)
  if (PublicationDate==""){PublicationDate = NA}
  
  #Abstract
  Abstract <- files[i]%>%read_html()%>%html_nodes("  #Abs1 ")%>%html_text()
  Abstract = gsub("\r\n"," ",Abstract)
  if (Abstract==""){Abstract = NA}
  
  #Keywords
  Keywords <- files[i]%>%read_html()%>%html_nodes(" .c-keywords ")%>%html_text()
  Keywords = gsub("\r\n", ",", Keywords)
  if (Keywords==""){Keywords = NA}
  
  #FullText
  FullText <- files[i]%>%read_html()%>%html_nodes("  article ")%>%html_text()
  FullText = gsub("\r\n", "", FullText)
  if (FullText==""){FullText = NA}
  
  result[i,] <- c(DOI,Title,Authors,AuthorAffiliations,CorrespondingAuthor,CorrespondingAuthorEmail,PublicationDate,Abstract,Keywords, FullText)
}

write.table(result,file = 'Hereditas.txt',append = T)
