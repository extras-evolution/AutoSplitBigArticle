//<?php
/**
 * AutoSplitBigArticle
 * 
 * will paginate a document when count delimiter per page is found in the content.
 *
 * @category    plugin
 * @version     1.1
 * @license     http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
 * @internal    @properties
 * @internal    @events OnLoadWebDocument
 * @internal    @modx_category Content
 * @internal    @legacy_names AutoSplitBigArticle
 * @internal    @installset base, sample
 */
 
## CUSTOMIZE ##
$delimiter = '<p';
$count_delimiter_per_page=20;
$tplLinkNext = '<a href="[+link+]">Next</a>';
$tplLinkPrev = '<a href="[+link+]">Prev</a>';
$tplLinkNav = '
  <div style="margin-top: 10px;font-size: small;">
  [+linkprev+]
   Page [+current+] of [+total+] 
  [+linknext+]
  </div>';
 
## DO NOT EDIT BELOW THIS LINE ##
$e = &$modx->Event;
 
switch($e->name) {
  case 'OnLoadWebDocument':
    $pip_content = $modx->documentObject['content'];
    $pip_content_p = explode($delimiter,$pip_content);
    $count_p = count($pip_content_p);
 
   $pip_pagecount=intval($count_p/$count_delimiter_per_page);
   if ($pip_pagecount*$count_delimiter_per_page <> $count_p) $pip_pagecount++;
 
    if ($pip_pagecount > 1)
    {
      $pip_currentpage = isset($_GET["page"]) ? $_GET["page"]: 1;
      if ($pip_currentpage > $pip_pagecount || $pip_currentpage < 1) { $pip_currentpage = 1; }
 
      $char = ($modx->config['friendly_urls'] == 0) ? "&" : "?";
      $url = $modx->makeurl($modx->documentObject["id"],'',$char.'page=');
 
      $prevpage = $pip_currentpage-1;
      $nextpage = $pip_currentpage+1;
 
      $linkprev = ($prevpage>0) ? str_replace("[+link+]",$url.$prevpage,$tplLinkPrev) : '';
      $linknext = ($nextpage>$pip_pagecount) ? '' : str_replace("[+link+]",$url.$nextpage,$tplLinkNext);
 
      $pip_template = str_replace("[+linkprev+]",$linkprev,$tplLinkNav);
      $pip_template = str_replace("[+linknext+]",$linknext,$pip_template);
      $pip_template = str_replace("[+total+]",$pip_pagecount,$pip_template);
      $pip_template = str_replace("[+current+]",$pip_currentpage,$pip_template);
      
          for ($i = $count_delimiter_per_page*$pip_currentpage-$count_delimiter_per_page+1;
                                $i <= $count_delimiter_per_page*$pip_currentpage; $i++)
          {
            if ($i >= $count_p) break;
            $pip_pagecontent.=$delimiter.$pip_content_p[$i];
          }
      $pip_content= $pip_pagecontent.$pip_template;
    }
 
    $modx->documentObject['content'] = $pip_content;
 
    break;
  default:
    return;
    break;
}