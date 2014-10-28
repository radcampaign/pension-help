#!/bin/sh
#pipe output to, say, ../test/selenium/complete test_suite.html
#TODO: don't inclue .svn files in subdirectories, directories, test_suites
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
echo "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">"
echo "<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\" lang=\"en\">"
echo "<head>"
echo "  <meta content=\"text/html; charset=UTF-8\" http-equiv=\"content-type\" />"
echo "  <title>Test Suite</title>"
echo "</head>"
echo "<body>"
echo "<table id=\"suiteTable\" cellpadding=\"1\" cellspacing=\"1\" border=\"1\" class=\"selenium\"><tbody>"
echo "<tr><td><b>Test Suite</b></td></tr>"
find ../test/selenium | sed -n 's/\.\.\/test\/selenium\/\([^\.].*$\)/<tr><td><a href=\"\1\">\1<\/a><\/td><\/tr>/p'
echo "</tbody></table>"
echo "</body>"
echo "</html>"
