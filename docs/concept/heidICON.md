# heidICON

The databases from heidICON and Berenike.project are linked.

In the Berenike.project database the berenike.table find has the following fields which link to heidICON:

- find.heidicon_id, integer
- find.heidicon_uuid, varchar
- find.heidicon_system_object_id, int

The folder /data/heidICON contains export files from the heidICON database in xml format which link to find records’ id in the Berenike.project databse by the following xpath

/objects/objekte/custom[@name='obj_beschreibung_link'][@type='custom:base.custom-data-type-link.link']/string[@name='url']/substring-after(text(), '/find/')

# import image data into Berenike.project database from heidICON xml

The folder /data/heidICON contains xml files from heidICON which contain image information that needs to be imported into the Berenike.project database.

Within the `objects` section, each `objekte` tag  object refers to a berenike.find record which can be retrieved by the xpath as described in the section above.

In the Bereninke.project database the fields `heidicon_id`, `heidicon_uuid` and `find.heidicon_system_object_id` should be filled with the respective information from the heidICON xml file as follows:

- find.heidicon_id << `/objects/objekte/_id` (e.g. 942472)
- find.heidicon_uuid << `/objects/objekte/_uuid` (e.g. b17bf1dd-a7e7-42c2-b441-8f57cbd9e20)
- find.heidicon_system_object_id << `/objects/objekte/_system_object_id` (e.g. 24093704)

Each find object as identified by `objekte` is related to several assets which can be found under the xpath `objekte/_standard-eas/files/file` which by the id inside the tag `eas-id` (e.g. 1272240) refer to a ressource under /object/ressourcen which also have a `eas-id` under `/objects/objekte/ressourcen/asset/files/file` under by which they can be mapped.

Each `reccourcen` object should be imported into the Berenike.project database table berenike.image which also has the heidICON fields `heidicon_id`, `heidicon_uuid` and `find.heidicon_system_object_id` like the berenike.find table. Likewise, the `ressourcen` tag contains the corresponding tags _id, _system_object_id, _uuid. Fill the fields of berenike.image as follows:

- id << primary key, set to auto increment
- find_id << foreign key pointing back to the corresponding find
- type << 'photo'
- number - not needed
- size << concatenation of `/objects/objekte/ressourcen/asset/files/file/technical_metadata/width`, ',' and `…/height`
- file << `/objects/objekte/ressourcen/asset/files/file/original_filename`
- path – not needed
- heidicon_id << `/objects/objekte/ressourcen/_id`
- heidicon_uuid << `/objects/objekte/ressourcen/_uuid`
- heidicon_system_object_id << `/objects/objekte/ressourcen/_system_object_id`

In addition to the information mentioned above, each photo has a photographer which can be found in the section `_nested__ressourcen__res_autoren`. These information is used to populate the Berenike.project database table `image_specialist` as follows:

id << auto generated
image_id << id of the image
specialist_id << the corresponding specialist can be found by using the gnd number `_nested__ressourcen__res_autoren/ressourcen__res_autoren/custom[@name='res_autor_gnd']/string[@name='conceptURI']` to find the related data record in the berenike.specialist table
speciality << will be 'photographer'
year << can be retrieved from `asset/files/file/date_created`, where the first four characters represent the date ('^\d\d\d\d')
