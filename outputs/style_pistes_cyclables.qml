<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="3.28">
  <renderer-v2 type="categorizedSymbol" attr="TYPE_VOIE_DESC">
    <categories>
      <category value="Piste cyclable en site propre" symbol="0" label="Piste en site propre" render="true"/>
      <category value="Bande cyclable" symbol="1" label="Bande cyclable" render="true"/>
      <category value="Piste cyclable sur rue" symbol="2" label="Piste sur rue" render="true"/>
      <category value="Chaussée désignée" symbol="3" label="Chaussée désignée" render="true"/>
      <category value="Sentier polyvalent" symbol="4" label="Sentier polyvalent" render="true"/>
    </categories>
    <symbols>
      <symbol type="line" name="0">
        <layer class="SimpleLine">
          <prop k="line_color" v="31,120,180,255"/>
          <prop k="line_width" v="1.5"/>
        </layer>
      </symbol>
      <symbol type="line" name="1">
        <layer class="SimpleLine">
          <prop k="line_color" v="51,160,44,255"/>
          <prop k="line_width" v="1.5"/>
        </layer>
      </symbol>
      <symbol type="line" name="2">
        <layer class="SimpleLine">
          <prop k="line_color" v="255,127,0,255"/>
          <prop k="line_width" v="1.5"/>
        </layer>
      </symbol>
      <symbol type="line" name="3">
        <layer class="SimpleLine">
          <prop k="line_color" v="227,26,28,255"/>
          <prop k="line_width" v="1.5"/>
        </layer>
      </symbol>
      <symbol type="line" name="4">
        <layer class="SimpleLine">
          <prop k="line_color" v="106,61,154,255"/>
          <prop k="line_width" v="1.5"/>
        </layer>
      </symbol>
    </symbols>
  </renderer-v2>
</qgis>
