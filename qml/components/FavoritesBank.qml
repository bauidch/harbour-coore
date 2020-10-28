import QtQuick 2.5
import QtQuick.LocalStorage 2.0

ListModel {
     id: model

     function __db()
     {
         return LocalStorage.openDatabaseSync("Coore", "1.0", "The Local Coore Bank", 1000);
     }
     function __ensureTables(tx)
     {
         tx.executeSql('CREATE TABLE IF NOT EXISTS favorites(location TEXT, location_id INTEGER)', []);
     }

     function fillModel() {
         __db().transaction(
             function(tx) {
                 __ensureTables(tx);
                 var rs = tx.executeSql("SELECT location, location_id FROM favorites ORDER BY location DESC", []);
                 model.clear();
                 if (rs.rows.length > 0) {
                     for (var i=0; i<rs.rows.length; ++i) {
                         var row = rs.rows.item(i);
                         model.append({"name":row.location,"id":row.location_id})
                     }
                 }
             }
         )
     }

     function addItem(location, location_id) {
              __db().transaction(
                  function(tx) {
                      __ensureTables(tx);
                      tx.executeSql("INSERT INTO favorites VALUES(?, ?)", [location, location_id]);
                      fillModel();
                  }
              )
          }
     function deleteItem(index, location) {
              __db().transaction(
                  function(tx) {
                      tx.executeSql("DELETE FROM favorites WHERE location=?", [location]);
                      model.remove(index);
                  }
              )
          }



     Component.onCompleted: {
         fillModel();
     }
 }
