Two simple angularJS directives using zurb's foundation 4 framework.

1) mp-dropdown 
	Example:
	<label>Person name: {{selectedPerson.name}}</label>
        <mp-dropdown dropdown-title="Person" dropdown-list="dropdownListData" dropdown-model="selectedPerson" dropdown-var="va" dropdown-repeat-text="va.name" dropdown-button-class="button dropdown" ></mp-dropdown>

2) mp-dropdown-content
	Example:
	 <mp-dropdown-content dropdown-title="404 Content" dropdown-list="Roles" dropdown-src="'404_content.html'" dropdown-content-class="f-dropdown content medium"   dropdown-button-class="button dropdown" d></mp-dropdown-content>

