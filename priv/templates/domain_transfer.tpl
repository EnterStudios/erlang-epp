<epp:epp xmlns:epp="urn:ietf:params:xml:ns:epp-1.0" xmlns:domain="urn:ietf:params:xml:ns:domain-1.0">
  <epp:command>
    <epp:transfer op="{{operation}}">
      <domain:transfer>
        <domain:name>{{name}}</domain:name>
      </domain:transfer>
    </epp:transfer>
  </epp:command>
</epp:epp>