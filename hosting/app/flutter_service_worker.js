'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "25def208ac96ed1d783886d48f658409",
"assets/AssetManifest.bin.json": "8e8097789ab072c35ea725d545ac6175",
"assets/AssetManifest.json": "6d1bfb202d2aed3ada39bd4923b9815f",
"assets/assets/audios/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/assets/fonts/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/assets/fonts/Lexend%2520Deca-Regular.ttf": "47e7cf64af81a528d189b300dfe60c30",
"assets/assets/fonts/Pharmabox.ttf": "124d29fbf54530a2c1cb66012f455577",
"assets/assets/fonts/Poppins-Medium.ttf": "bf59c687bc6d3a70204d3944082c5cc0",
"assets/assets/fonts/Poppins-Regular.ttf": "093ee89be9ede30383f39a899c485a82",
"assets/assets/fonts/Poppins-SemiBold.ttf": "6f1520d107205975713ba09df778f93f",
"assets/assets/groupements/Aelia.jpg": "66d4c3e996074d21150c8aafed47cd7b",
"assets/assets/groupements/Agir%2520Pharma.jpg": "10a0b169ed8bf2b98f852f580a6b870b",
"assets/assets/groupements/AGPF.jpg": "a794f05d713c71cbcff2833cbf74b1fc",
"assets/assets/groupements/Alphega%2520Pharmacie.jpg": "e23e26c3feecde0a64797f53134ec2ff",
"assets/assets/groupements/Altapharm.jpg": "c8e81258fd4a4bf17f94a0521243775c",
"assets/assets/groupements/Anton%2520&%2520Willem.jpg": "a8dc5da2d9a4ee32913282eb7e147066",
"assets/assets/groupements/APM.jpg": "2ca88f15ca4cc9045c19f5e949b98ae1",
"assets/assets/groupements/Apothical.jpg": "86fd2e4df254c8358e910c156bc5c0ed",
"assets/assets/groupements/Apothicoop.jpg": "86429c8ec2ccc96245cf84c1b5ebf1ce",
"assets/assets/groupements/Aprium%2520Pharmacie.jpg": "f77ddb95c3678ce317fe77f0137b28b3",
"assets/assets/groupements/Apsara.jpg": "f7578c7872ddbc5bc90751b5b7d62e45",
"assets/assets/groupements/Aptiphar.jpg": "3268bd0157eff1c9d77d4e7ba8e8b945",
"assets/assets/groupements/Arpilabe.jpg": "5f3909e1c9b5b5c13f60cc6741c7226c",
"assets/assets/groupements/Artisan%2520sant%25C3%25A9.jpg": "f9e88df611cb697151c9db9d80f9fd0c",
"assets/assets/groupements/Aucun.jpg": "e2618a85b3fa097baf9b998219986dbd",
"assets/assets/groupements/Autre.jpg": "bac73a808d67766d4649307c1fb2fd69",
"assets/assets/groupements/Boticinal.jpg": "484913b872ad1ee7a3c8c31d15f8c58c",
"assets/assets/groupements/Bretagne%2520Sant%25C3%25A9%2520R%25C3%25A9f%25C3%25A9rence.jpg": "60a35bfb0449650d217c6b68481e5e33",
"assets/assets/groupements/C%25C3%25B4t%25C3%25A9%2520pharma.jpg": "1dc82b9e319727cc4ca3cb2356803363",
"assets/assets/groupements/CABG%2520Pharmacie.jpg": "2cf396dab1d348e3f416c007b05a16d8",
"assets/assets/groupements/Cali%2520Pharma.jpg": "566d770d9c779627682f4b06f84f79b2",
"assets/assets/groupements/Cap%25E2%2580%2599Unipharm.jpg": "ea0daef73e9452e42a8e969a103cb9e3",
"assets/assets/groupements/Ceido.jpg": "630ad69837f9b60345028ec6b995af76",
"assets/assets/groupements/Centrale%2520des%2520Pharmaciens%2520-%2520Astera.jpg": "9f7636e84f7bfc81b5f12016dfe97c0f",
"assets/assets/groupements/Cofisant%25C3%25A9.jpg": "0e3feb064515a7f974ef731443f940f0",
"assets/assets/groupements/COS.jpg": "b728ac2223c3d039193fd33da4eb459a",
"assets/assets/groupements/Directlabo.jpg": "13d73e812da6ba60de1bf993c0394273",
"assets/assets/groupements/DPGS.jpg": "4607581c878076416b2d5ffd35b79acc",
"assets/assets/groupements/Dynamis.jpg": "0437f92717f6c0e90aa20b53448c058f",
"assets/assets/groupements/Dynaphar.jpg": "205625086a0ce1bc25ef8a255a1f4490",
"assets/assets/groupements/Elitpharma.jpg": "78e5475c23741b148059bae4ebf8d6aa",
"assets/assets/groupements/Elsie%2520Groupe.jpg": "9cc1d54d3bed2fd840c43014254c9ecc",
"assets/assets/groupements/Escale%2520Sant%25C3%25A9.jpg": "37036b3c3e72c8323de869a95cf500ba",
"assets/assets/groupements/Evolupharm.jpg": "52f10ba34e79fe8a59a35470c7bcfc4d",
"assets/assets/groupements/Excel%2520Pharma.jpg": "51295397fac9c35f5f7fd0bda9e43653",
"assets/assets/groupements/ExpansionPharma.jpg": "dd9903155af33709c84dfea01fa0e6ea",
"assets/assets/groupements/Familia.jpg": "17f0ae1a50576583f8f96253dcfc4e02",
"assets/assets/groupements/Farmax.jpg": "2d8aa4152783287f8f745ab793de5ca2",
"assets/assets/groupements/Forum%2520Sant%25C3%25A9.jpg": "0310eb37b9d4779212b648d2e871a268",
"assets/assets/groupements/G-Pharm.jpg": "9a36bc7798fdb2ea44800ac4f7b02599",
"assets/assets/groupements/G1000-Pharma.jpg": "a3a39a97cba0cd4dac6f7a0342f2a1ed",
"assets/assets/groupements/Giphar.jpg": "1419f25238ab0b9b1b591621e2d76cbb",
"assets/assets/groupements/Giropharm.jpg": "2cebdbf34b0983798e13c38e05038741",
"assets/assets/groupements/Global%2520Pharmacie.jpg": "0b7f083ae33d0c2d59e9d06dca48cf35",
"assets/assets/groupements/Grap.jpg": "42b4d2f9d71ce3119d098fcfcb2acd4a",
"assets/assets/groupements/Gripamel%2520Pro%2520Sant%25C3%25A9.jpg": "7c5fc78ef107efa0756f069aeb47a32b",
"assets/assets/groupements/Groupe%2520Rocade.jpg": "4999eeed10c150d901a766b0d90964ad",
"assets/assets/groupements/Groupe%2520Univers%2520Pharmacie.jpg": "c72922f0929d42dcc1b5cdfcb17b953f",
"assets/assets/groupements/Hello%2520Pharmacie.jpg": "a1f536fda2a7276009f8fd0dae59de61",
"assets/assets/groupements/HexaPharm.jpg": "47e3d29593b94262cf42c137bcb6748a",
"assets/assets/groupements/HPI%2520Totum.jpg": "c03642032b8370d5aa706731668ed9a5",
"assets/assets/groupements/IFMO.jpg": "302e6167c904ba2b14b294468bb228ac",
"assets/assets/groupements/iPharm.jpg": "efb6c8d21222203dacee2ffb5b2a5e24",
"assets/assets/groupements/Leadersant%25C3%25A9.jpg": "6c75bfdfddb814beb1bca9a4b96239e6",
"assets/assets/groupements/Les%2520Nouvelles%2520Pharmacies.jpg": "9b8b1d73c2a19e5063235a5b9d1693c2",
"assets/assets/groupements/Les%2520Pharmaciens%2520Associ%25C3%25A9s.jpg": "3b78564dccf41e18440e4670f4a45070",
"assets/assets/groupements/Les%2520pharmaciens%2520d%25E2%2580%2599Armor.jpg": "05d057c0bb08556f7cf90e2592ab8a21",
"assets/assets/groupements/Les%2520Pharmaciens%2520Unis.jpg": "02e1f86ac274827c08727a957baa1ac7",
"assets/assets/groupements/Mediprix.jpg": "9c435b4b79828c06b1025f7f3440db7c",
"assets/assets/groupements/Multipharma.jpg": "69e8f27c98f30f6ef84b674c8870abd0",
"assets/assets/groupements/Mutualpharm.jpg": "c25b5c3ce94e5aad76abff2ef0583916",
"assets/assets/groupements/N%25C3%25A9penth%25C3%25A8s.jpg": "8d229f2d0e26fd3b77e6a29774e985fd",
"assets/assets/groupements/Norpharma.jpg": "d1f5ece2da7dbd8008e033727e06f7f3",
"assets/assets/groupements/Objectif%2520Pharma.jpg": "31cf808003a5578ccf0383a4b4dee6a6",
"assets/assets/groupements/OmnesPharma.jpg": "ba968bde6b6d58546cba077cf507b52c",
"assets/assets/groupements/Optipharm.jpg": "f178a6b4bd6e2b54818a4af1f4254911",
"assets/assets/groupements/OriginSant%25C3%25A9.jpg": "efe3f649f6d205a89511b925147bdd7a",
"assets/assets/groupements/Ospharea.jpg": "823684f93c05a04ef96a232570640163",
"assets/assets/groupements/Ot%25C3%25A9%2520Pharma.jpg": "b4feb82caf2d00cdb860e23363cab753",
"assets/assets/groupements/Paraph.jpg": "8cf3ca713baee1d33c53c0cdd7a702db",
"assets/assets/groupements/Paris%2520Pharma.jpg": "64ea952d0ac992c07a4ad69398b5005e",
"assets/assets/groupements/Pharm%2520&%2520Price.jpg": "10863eeb165b51d725571442ff10b502",
"assets/assets/groupements/Pharm%2520&%2520You.jpg": "5b660ea8bdf796d1d37241967865e95b",
"assets/assets/groupements/Pharm%2520Avenir.jpg": "b8c0c1f9538574b3b7a4c52ebfa7b0cd",
"assets/assets/groupements/Pharm%2520O%25E2%2580%2599naturel.jpg": "65a14d603025733cc59685de13772a28",
"assets/assets/groupements/Pharm&Free.jpg": "29efe8d566cf32fc18f37e892ee82e00",
"assets/assets/groupements/Pharm'Indep.jpg": "1b9753fbff8320d48724abf660c137b5",
"assets/assets/groupements/Pharm-Upp.jpg": "3455e1085e39c6c1dda1b07d983159df",
"assets/assets/groupements/Pharma%252010.jpg": "4087a35e0eac88e5caa5a012a2c06202",
"assets/assets/groupements/Pharma%2520Direct.jpg": "287140de62be473ddb63fd334409d6a8",
"assets/assets/groupements/Pharma%2520XV.jpg": "d8b070e1d0cce50b612b7f1b3f7efb9b",
"assets/assets/groupements/Pharmabest.jpg": "a250612bd012714c493a933e108ef602",
"assets/assets/groupements/Pharmacie%2520Lafayette.jpg": "92daf32e74d030e54e0563233cf6bc39",
"assets/assets/groupements/Pharmacie%2520Populaire.jpg": "29fd95b0416ba00620e371aadef7c223",
"assets/assets/groupements/Pharmacies%2520Le%2520Gall.jpg": "38bfe6b8fa092afaf8bec4a64d98b7d0",
"assets/assets/groupements/PharmaCorp.jpg": "28bee097788b321a9072a973326781a7",
"assets/assets/groupements/Pharmactiv.jpg": "82074267f3e4d8f3eb72c69155f224ae",
"assets/assets/groupements/Pharmacyal.jpg": "910f74a3b67630eaf01f7d757106f379",
"assets/assets/groupements/Pharmadinina.jpg": "e9c6f26a9b21b34bd22e00acd23c0ea1",
"assets/assets/groupements/PharmaGroupSant%25C3%25A9.jpg": "3ef649b3d730e184e5ae840e496bfb64",
"assets/assets/groupements/PharmaPlatinum.jpg": "664430ecf6fe9f7bad872631e9e79ad8",
"assets/assets/groupements/Pharmarket.jpg": "79826b37b227d3f6130f7e62384bda11",
"assets/assets/groupements/Pharmasud.jpg": "5ed67dc1a416e8b1bcf1c79dcd9f0abe",
"assets/assets/groupements/PharmAvance.jpg": "4695e8b9643815cb192dba29fd197542",
"assets/assets/groupements/Pharmavie.jpg": "4e9da5ab24e31940df49e18cd01212af",
"assets/assets/groupements/PharmICI.jpg": "9f3b79e2ef899b977dd2868a3442b87d",
"assets/assets/groupements/Pharmodel.jpg": "afc67df6d3bdf7aeb0132cf93b71f2e6",
"assets/assets/groupements/PHR%2520R%25C3%25A9f%25C3%25A9rence.jpg": "e16561536197f2b3e2c07ecc2e3dd1e3",
"assets/assets/groupements/PUC%2520Pharma.jpg": "791ebf249fc5f7e47385f4463027078e",
"assets/assets/groupements/Quartz.jpg": "37fef2e02f8b54ef241db59097b028d2",
"assets/assets/groupements/R%25C3%25A9seau%2520P&P.jpg": "b1bf3ebec6dab6a981b898cc790b0ec8",
"assets/assets/groupements/R%25C3%25A9seau%2520Sant%25C3%25A9.jpg": "1d2a7b18f9a93ded41f73fe3495143e8",
"assets/assets/groupements/R%25C3%25A9sonor.jpg": "fb2761c3744df0486a6f78f08a321211",
"assets/assets/groupements/Resofficine.jpg": "03f487ba46a5725b3211bb513515e660",
"assets/assets/groupements/Simplypharma.jpg": "1babe97109d372a1a2c05cc62e5e78b2",
"assets/assets/groupements/Socopharm.jpg": "3d630540e361e70c0c423ceeef31b0e8",
"assets/assets/groupements/SocoPharma.jpg": "a80c3b18d0e89e72b38b14318bfc3dd6",
"assets/assets/groupements/Sofiadis.jpg": "30467cb2717496cea00a8bf17c9487e2",
"assets/assets/groupements/Sopharef.jpg": "95b2f5841e5e88da4b73968422148dbc",
"assets/assets/groupements/Sud%2520Aquitaine%2520Pharmaceutique.jpg": "9a8d5d930576830fcc5a8545162226e9",
"assets/assets/groupements/Sunipharma.jpg": "2725038c9426f0d2adb0fc96d5a25bbd",
"assets/assets/groupements/Suprapharm.jpg": "08dd9d1f19c6100aa06d17e0738a39a1",
"assets/assets/groupements/SynergiPhar.jpg": "146235ab4e2386fc6ffa4ccb6f376fab",
"assets/assets/groupements/Union%2520des%2520Grandes%2520Pharmacies%2520(UGP).jpg": "093164a0771fcbcd4b62dcd284349552",
"assets/assets/groupements/Unipharm%252033.jpg": "22aab0ea04d3fae6ba94952ef9d03493",
"assets/assets/groupements/Unipharm%2520Loire%2520Oc%25C3%25A9an.jpg": "520656224f9108c4a396992cfc44d8db",
"assets/assets/groupements/Unipharm.jpg": "c2257e798e9e76dbd45aa039f4e8ef09",
"assets/assets/groupements/UPIE.jpg": "e4f6157cbe5bf5cd7bd53065ab7e99f1",
"assets/assets/groupements/Upsem.jpg": "943ef9f670b54eb51f26f5bce0a666bf",
"assets/assets/groupements/Vitapharma.jpg": "293a92feb4ef37f0b6353ed828fd288a",
"assets/assets/groupements/VPharma.jpg": "6b61d6c733848937da485f4f27671bb0",
"assets/assets/groupements/Well&well%2520les%2520Pharmaciens.jpg": "863a6a1240dfdc0d189b7fc8a8512dc8",
"assets/assets/groupements/Wellpharma.jpg": "1ad909bcbca9c490c96529fe249bdbe7",
"assets/assets/icons/24H.svg": "65dd403fc7b8e56602e408f4e1c738a9",
"assets/assets/icons/Badge-Or.svg": "08eff84aafc41e6fd1749e7643c37c5c",
"assets/assets/icons/bebe.svg": "3dc116238a13ef81f551f2da8c736e21",
"assets/assets/icons/Bot.svg": "80400e6e5fac38a5abdd6ad006f1d905",
"assets/assets/icons/chauffage.svg": "9f46647defb58804c9b26e0da379ce77",
"assets/assets/icons/clim.svg": "33478c47c6ac2f7b481dc249864c1db0",
"assets/assets/icons/Contrat.svg": "cb8b3c954ca9acaba58d7d66ffe09c68",
"assets/assets/icons/Entretien.svg": "3d1e3537fdd7c14c4bcc2888c39bd996",
"assets/assets/icons/Groups.svg": "1f110fbd7fecbca3681d06c28786254f",
"assets/assets/icons/Home-Indicator.svg": "f88862a423e1e212b5300315473279dc",
"assets/assets/icons/labs.svg": "c037216ecaf7ae7c3484d73f55fa2001",
"assets/assets/icons/Like.svg": "d0e47b5b81db5b6df94b829742f00ef2",
"assets/assets/icons/logo-pharma-box.png": "50aedd1f481959e68cb6a032553391b2",
"assets/assets/icons/Message.svg": "48ec69baefc46bd6308dbd89e59ef65e",
"assets/assets/icons/moneyeur.svg": "cc8588f37993fdc5b92d545ce02776f8",
"assets/assets/icons/nutrition.svg": "8b731a943ca5dd6994af33d1500b9fd5",
"assets/assets/icons/ordonances.svg": "23362c9d345ca7acc10a9e495f55844c",
"assets/assets/icons/Pause.svg": "7fcb7d9a3d45d7797bd2bd407006d1f3",
"assets/assets/icons/phyto.svg": "9d4ed5d565fb3cecf8301bc6b2cbbc77",
"assets/assets/icons/qrcode.svg": "46d6b87ad39f4cd5389fb84235be9a01",
"assets/assets/icons/quartier.svg": "3d4e480187054efce325519fbdce3b85",
"assets/assets/icons/question.svg": "ca56a3ced25e6738e5014d992c670ac1",
"assets/assets/icons/shield1.svg": "163fa0958ec7967bd4d6683bbddf61ab",
"assets/assets/icons/Vaccines.svg": "9506b90778ad431f727f9772553fc005",
"assets/assets/icons/vigile.svg": "b0b088b3afab45fd3588bcec749bdf75",
"assets/assets/images/AppleConnect.png": "441a508c71767c611d20ba0afdfd9784",
"assets/assets/images/Badge.png": "7a46793d1e7c7f1a3d2e23c4b6354a2f",
"assets/assets/images/Badge2.png": "5e036a0606905d920f7a392602586ba5",
"assets/assets/images/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/assets/images/Frame_88.png": "1772395a20fae2ea0b98395ec7d58123",
"assets/assets/images/Google.png": "22966a5a56cddad903bd82f783b2f722",
"assets/assets/images/Group_18.png": "70bfde3414efa4a2cded52f29887ab47",
"assets/assets/images/Group_19.png": "3922d4b3ede7e911d7d3b9f0a2bee6a5",
"assets/assets/images/Mail.png": "0173de3e1a5b77e20b28025b28b4e83e",
"assets/assets/images/messagesEmpty@2x.png": "d44bfb3ca2a122becc62021ece970173",
"assets/assets/lgo/ActiPharm.jpg": "36565be9db43f3776d78fb9f9e455283",
"assets/assets/lgo/CADUCIEL.jpg": "a98b34faffe4af6914d73ba01a9bebf1",
"assets/assets/lgo/Crystal.jpg": "7ac8dfbdc5ce0969c17eaf6633aa6013",
"assets/assets/lgo/Giphar.jpg": "d38ff3562d2868320b7633df4b32ca75",
"assets/assets/lgo/Leo.jpg": "93fd76dee78e5c1990561657e08d9421",
"assets/assets/lgo/LGPI.jpg": "fd0366b01d7404cd770cec30119130e4",
"assets/assets/lgo/Pharmagest.jpg": "078d39d63d929139f7a88a0120f784d7",
"assets/assets/lgo/Pharmaland.jpg": "e9f6398a527ac09ed97c9276e17483ae",
"assets/assets/lgo/PharmaVitale.jpg": "9555e9ffac908611bca14e83188e25ac",
"assets/assets/lgo/Pharmony.jpg": "e3f397952919fab3ef222a1b8562f660",
"assets/assets/lgo/SMART_RX.jpg": "005aed6f97ec050561d13af7d25bf0c5",
"assets/assets/lgo/Vindilis.jpg": "d6f65c0175976beb9bf7d5e37c48b19c",
"assets/assets/lgo/Visiopharm.jpg": "36f10668d3ca81c922d5737a4ba653b5",
"assets/assets/lgo/Winpharma.jpg": "f467272d338bf3ec2bb3410228228b6f",
"assets/assets/lottie_animations/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/assets/pdfs/CGU-Pharma-box.pdf": "cf011da4c04a27cfc5ae74365dea0d24",
"assets/assets/pdfs/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/assets/rive_animations/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/assets/videos/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/FontManifest.json": "f67963c4fff69d3647f0cf5fb5609fea",
"assets/fonts/MaterialIcons-Regular.otf": "2e6437c8e28d1eff51e4fefedc800b54",
"assets/NOTICES": "c87c9eea6dacbaae6be0e8414e65b997",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "83702ed7b950907257df85acd61eb6df",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "4769f3245a24c1fa9965f113ea85ec2a",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "3ca5dc7621921b901d513cc1ce23788c",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "a2eb084b706ab40c90610942d98886ec",
"assets/packages/stopwordies/assets/jsons/sw-af.json": "48dee102abdab31b9ba0ea41a3d17e28",
"assets/packages/stopwordies/assets/jsons/sw-ar.json": "c4f4453445d66fd1b4080989c674a072",
"assets/packages/stopwordies/assets/jsons/sw-bg.json": "6d454df1165def2f039a7bdea31232da",
"assets/packages/stopwordies/assets/jsons/sw-bn.json": "657a0e19dcddb36c4d0b2772a1d9c4a9",
"assets/packages/stopwordies/assets/jsons/sw-br.json": "e2f1a140823ef79cf903f3da01039c73",
"assets/packages/stopwordies/assets/jsons/sw-ca.json": "d5790c2050e8760d648b486406b2e38a",
"assets/packages/stopwordies/assets/jsons/sw-cs.json": "a465a4a3d5b1338a283a1073a5f6dac9",
"assets/packages/stopwordies/assets/jsons/sw-da.json": "3addded6e6e0dcfec0b9d3f9bd7a259d",
"assets/packages/stopwordies/assets/jsons/sw-de.json": "90fcd54bc311a23da39938c0335e9438",
"assets/packages/stopwordies/assets/jsons/sw-el.json": "4f1ad9caead21bf85a5378d477b523be",
"assets/packages/stopwordies/assets/jsons/sw-en.json": "d29af31cdb15b56c4baf812cae27675c",
"assets/packages/stopwordies/assets/jsons/sw-eo.json": "b822dd283ab3b4547f87862ff49d4c6f",
"assets/packages/stopwordies/assets/jsons/sw-es.json": "51adb8900e519d98418debe03fa0b2c1",
"assets/packages/stopwordies/assets/jsons/sw-et.json": "7b2131e5986a160b36eb52fea3b4995d",
"assets/packages/stopwordies/assets/jsons/sw-eu.json": "c0a0f2b730725a3ac5b0681d8ecf26c6",
"assets/packages/stopwordies/assets/jsons/sw-fa.json": "5814bc930aa7b654e059060492260a46",
"assets/packages/stopwordies/assets/jsons/sw-fi.json": "4c0350c18b1ba76bc40a0e05157bb192",
"assets/packages/stopwordies/assets/jsons/sw-fr.json": "c47f0ad12d194b01695c1d09139f02a6",
"assets/packages/stopwordies/assets/jsons/sw-ga.json": "be770187e0b94613f76d1eacc230837b",
"assets/packages/stopwordies/assets/jsons/sw-gl.json": "ed5fd4d126b2b11fb94200ba1c074f6a",
"assets/packages/stopwordies/assets/jsons/sw-gu.json": "ecdaaa32669e44839eb8d78f36e5f7f4",
"assets/packages/stopwordies/assets/jsons/sw-ha.json": "6f0740041e532c3ee4d9253d10ee39aa",
"assets/packages/stopwordies/assets/jsons/sw-he.json": "dce5b75e6a40bdd54a4a34d936417413",
"assets/packages/stopwordies/assets/jsons/sw-hi.json": "deedbfc3e851e4d815deea3e3b142fa4",
"assets/packages/stopwordies/assets/jsons/sw-hr.json": "8a33653a32949da457df1a39e2f07baf",
"assets/packages/stopwordies/assets/jsons/sw-hu.json": "5db18c259d8722b0700a8d7e6f644804",
"assets/packages/stopwordies/assets/jsons/sw-hy.json": "c040596e0ec474195b32e51561aaee21",
"assets/packages/stopwordies/assets/jsons/sw-id.json": "45144718a16ce58e84b96a30cd80d9e6",
"assets/packages/stopwordies/assets/jsons/sw-it.json": "f2d4bc0fc185a46c819b06dec838e2c1",
"assets/packages/stopwordies/assets/jsons/sw-ja.json": "a4fa6ea7704056d851ab335f05750654",
"assets/packages/stopwordies/assets/jsons/sw-ko.json": "32e036d9c65e0cc3c824e97e9e7ae5ff",
"assets/packages/stopwordies/assets/jsons/sw-ku.json": "d290960692df3c159dcc7a407bf86dfb",
"assets/packages/stopwordies/assets/jsons/sw-la.json": "e159b8fd394a112e2cf88eec4bab7241",
"assets/packages/stopwordies/assets/jsons/sw-lt.json": "9fa3da57efd572e5bdedc70282a7d023",
"assets/packages/stopwordies/assets/jsons/sw-lv.json": "39623a81c51e9a2e095ba5d31c24c1a4",
"assets/packages/stopwordies/assets/jsons/sw-mr.json": "02b96cc56926cc9d7fd8a4ed2273fd94",
"assets/packages/stopwordies/assets/jsons/sw-ms.json": "8608a3b79db205b3bfd75a64235eb83c",
"assets/packages/stopwordies/assets/jsons/sw-nl.json": "cd64a6404a645108db7bef5ef2352198",
"assets/packages/stopwordies/assets/jsons/sw-no.json": "d2e622bf9f8508b7ce537e689ce4d91a",
"assets/packages/stopwordies/assets/jsons/sw-pl.json": "89230b7050892093fc50cc2ed8f188d1",
"assets/packages/stopwordies/assets/jsons/sw-pt.json": "9b7235fb9b075d404d3ef5ff60a39123",
"assets/packages/stopwordies/assets/jsons/sw-ro.json": "a75a2641c0c3dcfdb77e01ea9908e414",
"assets/packages/stopwordies/assets/jsons/sw-ru.json": "17395ef3d5e41a8340efdadcc3e3d593",
"assets/packages/stopwordies/assets/jsons/sw-sk.json": "d919a91282435c2cb379f576d08a1165",
"assets/packages/stopwordies/assets/jsons/sw-sl.json": "6ee77374fc2a2dfad44a610b0b0e384f",
"assets/packages/stopwordies/assets/jsons/sw-so.json": "d4fa50f22de8065a768f9ecb1754f682",
"assets/packages/stopwordies/assets/jsons/sw-st.json": "4de21db6f32adb2f2fc28e379418c49f",
"assets/packages/stopwordies/assets/jsons/sw-sv.json": "994039ea98a0dd01afd43f026a8bd0ad",
"assets/packages/stopwordies/assets/jsons/sw-sw.json": "993485eb5fd124a679b68aa015cb1fb2",
"assets/packages/stopwordies/assets/jsons/sw-th.json": "2cafd5ac0db97e79cdbfed958fcaa911",
"assets/packages/stopwordies/assets/jsons/sw-tl.json": "13b2cda8740c0684b0f6b545230966a2",
"assets/packages/stopwordies/assets/jsons/sw-tr.json": "442c708eae931f752b749a74fb3228f4",
"assets/packages/stopwordies/assets/jsons/sw-uk.json": "da6f4a19bb41d7fa532f5c2e26ad3f6c",
"assets/packages/stopwordies/assets/jsons/sw-ur.json": "0c13fdf6439dacc95622e0c8fd2258d4",
"assets/packages/stopwordies/assets/jsons/sw-vi.json": "e9376778578d7dcd0144c036b7c9efe7",
"assets/packages/stopwordies/assets/jsons/sw-yo.json": "0b953c3267df7f87e189a45223424940",
"assets/packages/stopwordies/assets/jsons/sw-zh.json": "0d52dc4038fadf2adfd8d88627f8c62b",
"assets/packages/stopwordies/assets/jsons/sw-zu.json": "fbf98d63c2b315a2cd3d71f8441e807a",
"assets/packages/syncfusion_flutter_datepicker/assets/fonts/Roboto-Medium.ttf": "7d752fb726f5ece291e2e522fcecf86d",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "27361387bc24144b46a745f1afe92b50",
"canvaskit/canvaskit.wasm": "a37f2b0af4995714de856e21e882325c",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "f7c5e5502d577306fb6d530b1864ff86",
"canvaskit/chromium/canvaskit.wasm": "c054c2c892172308ca5a0bd1d7a7754b",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "9fe690d47b904d72c7d020bd303adf16",
"canvaskit/skwasm.wasm": "1c93738510f202d9ff44d36a4760126b",
"favicon.png": "2704101cb06ce66e2000356a312be25c",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"flutter_bootstrap.js": "faca046f423ef28e9379123819308b86",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"index.html": "3caf4b5419b076bbc96ea0d2fc66de0b",
"/": "3caf4b5419b076bbc96ea0d2fc66de0b",
"main.dart.js": "acbca8dfa0fbc5f0f6b6cff19a99f348",
"version.json": "3c5920d979b79da61834ded51353885d"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
