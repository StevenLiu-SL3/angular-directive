Two simple angularJS directives using zurb's foundation 4 framework.

1) mp-dropdown 
	Example:
	&lt;label&gt;Person name: {{selectedPerson.name}}&lt;/label&gt;
        &lt;mp-dropdown dropdown-title=&quot;Person&quot; dropdown-list=&quot;dropdownListData&quot; dropdown-model=&quot;selectedPerson&quot; dropdown-var=&quot;va&quot; dropdown-repeat-text=&quot;va.name&quot; dropdown-button-class=&quot;button dropdown&quot; &gt;&lt;/mp-dropdown&gt;

2) mp-dropdown-content
	Example:
	 &lt;mp-dropdown-content dropdown-title=&quot;404 Content&quot; dropdown-list=&quot;Roles&quot; dropdown-src=&quot;'404_content.html'&quot; dropdown-content-class=&quot;f-dropdown content medium&quot;   dropdown-button-class=&quot;button dropdown&quot; d&gt;&lt;/mp-dropdown-content&gt;

3) mp-clearing
	Example:
	  &lt;div mp-clearing clearing-image-list=&quot;imageListData&quot;&gt;&lt;/div&gt;

    
