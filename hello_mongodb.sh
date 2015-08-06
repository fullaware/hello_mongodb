# This will install and and test Nodejs + MongoDB 3.x
# on CentOS 6.x

echo $'\n ###  Run as root  ###\n'

echo $'\n ###  Creating /etc/yum.repos.d/mongodb-org-3.0.repo  ###\n'

cat > /etc/yum.repos.d/mongodb-org-3.0.repo << EOF
[mongodb-org-3.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/\$releasever/mongodb-org/3.0/x86_64/
gpgcheck=0
enabled=1
EOF

echo $'\n ###  Installing Extra Packages for Enterprise Linux 6.x [EPEL]  ###\n'
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm

echo $'\n ###  Installing nodejs  ###\n'
yum install -y nodejs npm gcc-c++ make --enablerepo=epel

echo $'\n ###  Installing mongodb-org  ###\n'
yum install -y mongodb-org

echo $'\n ###  Creating hello_world_mongodb in root folder  ###\n'
mkdir ~/hello_world_mongodb
cd ~/hello_world_mongodb

echo $'\n ###  Creating package.json  ###\n'
cat > package.json << EOF
{
  "name": "hello_world_mongodb",
  "version": "0.0.0",
  "description": "Hello World MongoDB Style",
  "main": "app.js",
  "dependencies": {
    "mongodb": "~1.3.10"
  },
  "author": "Shaun Verch",
  "license": "BSD"
}
EOF

echo $'\n ###  Creating app.js  ###\n'
cat > app.js << EOF
var MongoClient = require('mongodb').MongoClient;

// Open the connection to the server
MongoClient.connect('mongodb://127.0.0.1:27017/test', function(err, db) {
    if(err) throw err;

    // Find one document in our collection
    db.collection('coll').findOne({}, function(err, doc) {

        if(err) throw err;

        // Print the result.
        // Will print a null if there are no documents in the db.
        console.dir(doc);

        // Close the DB
        db.close();
    });

    // Declare success
    console.dir("Called findOne!");
});
EOF

echo $'\n ###  Running 'npm install' in hello_world_mongodb folder  ###\n'
npm install

echo $'\n ###  Populating mongodb 'coll' collection with "name" : "MongoDB"  ###\n'
mongo --eval 'db.coll.save({"name":"MongoDB"});'

echo $'\n ###  Executing the app.js  ###\n'
node app.js
