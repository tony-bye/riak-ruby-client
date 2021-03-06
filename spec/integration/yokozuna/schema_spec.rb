# Copyright 2010-present Basho Technologies, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'spec_helper'
require 'riak'

describe "Yokozuna", test_client: true, integration: true do
  before(:all) do
    @client = test_client

    @index = 'yz_spec-' + random_key
    @schema = 'yz_spec-' + random_key
  end

  context 'with no schema' do
    it 'allows schema creation' do
      @client.create_search_schema(@schema, SCHEMA_CONTENT)
      wait_until{ !@client.get_search_schema(@schema).nil? }
      expect(@client.get_search_schema(@schema)).not_to be_nil
    end
  end
  context 'with a schema' do
    it 'has a readable schema' do
      @client.create_search_schema(@schema, SCHEMA_CONTENT)
      wait_until{ !@client.get_search_schema(@schema).nil? }
      schema_resp = @client.get_search_schema(@schema)
      expect(schema_resp.name).to eq(@schema)
      expect(schema_resp.content).to eq(SCHEMA_CONTENT)
    end
  end

  SCHEMA_CONTENT = <<-XML
<?xml version=\"1.0\" encoding=\"UTF-8\" ?>
<schema name=\"#{@index}\" version=\"1.5\">
<fields>
   <field name=\"_yz_id\" type=\"_yz_str\" indexed=\"true\" stored=\"true\" multiValued=\"false\" required=\"true\" />
   <field name=\"_yz_ed\" type=\"_yz_str\" indexed=\"true\" stored=\"true\" multiValued=\"false\"/>
   <field name=\"_yz_pn\" type=\"_yz_str\" indexed=\"true\" stored=\"true\" multiValued=\"false\"/>
   <field name=\"_yz_fpn\" type=\"_yz_str\" indexed=\"true\" stored=\"true\" multiValued=\"false\"/>
   <field name=\"_yz_vtag\" type=\"_yz_str\" indexed=\"true\" stored=\"true\" multiValued=\"false\"/>
   <field name=\"_yz_rk\" type=\"_yz_str\" indexed=\"true\" stored=\"true\" multiValued=\"false\"/>
   <field name=\"_yz_rb\" type=\"_yz_str\" indexed=\"true\" stored=\"true\" multiValued=\"false\"/>
   <field name=\"_yz_rt\" type=\"_yz_str\" indexed=\"true\" stored=\"true\" multiValued=\"false\"/>
   <field name=\"_yz_err\" type=\"_yz_str\" indexed=\"true\" stored=\"true\" multiValued=\"false\"/>
</fields>
<uniqueKey>_yz_id</uniqueKey>
<types>
    <fieldType name=\"_yz_str\" class=\"solr.StrField\" sortMissingLast=\"true\" />
</types>
</schema>
      XML
end
