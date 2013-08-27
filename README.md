Example of AngularJS integration of zurb's foundation 4 framework using custom directives<br>
<br>
&nbsp;1) mp-dropdown<br>
<br>
&nbsp;Example: &lt;label&gt;Person name:
{{selectedPerson.name}}&lt;/label&gt; &lt;mp-dropdown
dropdown-title="Person" dropdown-list="dropdownListData"
dropdown-model="selectedPerson" dropdown-var="va"
dropdown-repeat-text="va.name" dropdown-button-class="button dropdown"
&gt;&lt;/mp-dropdown&gt;
<br>
<br>
2) mp-dropdown-content
	<br>
<br>
Example: &lt;mp-dropdown-content dropdown-title="404 Content"
dropdown-list="Roles" dropdown-src="'404_content.html'"
dropdown-content-class="f-dropdown content medium"
dropdown-button-class="button dropdown"
d&gt;&lt;/mp-dropdown-content&gt;<br>
<br>
3) mp-clearing
	<br>
<br>
Example:
	  &lt;div mp-clearing clearing-image-list="imageListData"&gt;&lt;/div&gt;<br>
<br>
<br>
<span style="font-weight: bold; text-decoration: underline;">Running the examples</span><br>
<br>
Assuming you have a working nodejs environment working with working npm and grunt installation<br>
&nbsp;<br>
1) Download the zip and unzip the zip file or git clone the source <br>
<br>
In the project directory, <br>
<br>
2) run "npm install"<br>
3) grunt server<br>
<br>
*Note: if you encountered any missing package dependency please install by npm install <br>
