<epp:epp xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xmlns:epp="urn:ietf:params:xml:ns:epp-1.0"  
xmlns:domain="urn:ietf:params:xml:ns:domain-1.0" 
xsi:schemaLocation="urn:ietf:params:xml:ns:epp-1.0 epp-1.0.xsd">
  <epp:command>
    <epp:delete>
      <domain:delete xsi:schemaLocation="urn:ietf:params:xml:ns:domain-1.0 domain-1.0.xsd">
        <domain:name>{{name}}</domain:name>
      </domain:delete>
    </epp:delete>
  </epp:command>
</epp:epp>
