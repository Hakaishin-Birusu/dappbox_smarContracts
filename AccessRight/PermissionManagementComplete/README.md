Created the documents and folder contract seperately and  migrated to testrpc


Sandeeps-MacBook-Pro:PermissionManagementComplete sandeep$ truffle migrate --reset
Using network 'development'.

Running migration: 1_initial_migration.js
  Replacing Migrations...
  ... 0x69fcdd3d8d969d1a667655e0bbd48b2bab86dfc41b175907b3bf430792ae0c1b
  Migrations: 0x1302bb93ba8bbc09e4ca331ad98c13913aa7653c
Saving successful migration to network...
  ... 0x5375f3174ad59047aebbaf3f51a5bef47e0bd86ed2b32d07d263774bb84b647d
Saving artifacts...
Running migration: 2_secondary_migration.js
  Replacing Dependency...
  ... 0x93f61ac9dbd0e2b97b52ffb1015ae15a8c17efe445f66f126e76e2c9308b0bf4
  Dependency: 0x3705fa90fad93b8f16ef1fa2423f5042d866197b
  Replacing DocDependency...
  ... 0xd0b4d47d468f54bab2983f98b8629243940ff2813723ac3eb0bda76b2dc5fdf4
  DocDependency: 0x7ae2df4b8ddd4a23712eddcb80dfb0f600e8b807
  Replacing NotarizationManagement...
  ... 0xec0c8eadae2c61a8e68853f49da65501e51f38e21c36857e0e4b8f93bcd1458d
  NotarizationManagement: 0x82b2ba44b47500ef5a4e15f2ec71aded0613cf61
  Replacing FolderPermissionManagement...
  ... 0x09d04a28dd950d5e8da71efc839f2d4880ece6fdb5f02aec605d183639428c4e
  FolderPermissionManagement: 0x42ab44eeeb9f825cea6ee0bbc4592cb92d994309
  Replacing DocPermissionManagement...
  ... 0xea5d67531ed5d94078d8d64db233cb94b37e850cc13dfeab12ee208063c28ad4
  DocPermissionManagement: 0xc00a8975f2ad09ef05c1638a61b0de48dd4ff6dc
Saving successful migration to network...
  ... 0x6b05aca39edea1d502f26819cc7b577b35dfdc027f17c2dedb80154fc7054d70
Saving artifacts...