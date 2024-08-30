// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<20x20xf64> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0:2 = call @inputs() : () -> (tensor<20x20xf64>, tensor<20x20xf64>)
    %1 = call @expected() : () -> tensor<20x20xf64>
    %2 = stablehlo.atan2 %0#0, %0#1 : tensor<20x20xf64>
    stablehlo.custom_call @check.expect_close(%2, %1) {has_side_effect = true} : (tensor<20x20xf64>, tensor<20x20xf64>) -> ()
    return %2 : tensor<20x20xf64>
  }
  func.func private @inputs() -> (tensor<20x20xf64> {mhlo.layout_mode = "default"}, tensor<20x20xf64> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x5CE34A09E72ED53FBE4A0259FAE91040010E345C1C8B10404E55F5020714E2BF2F97A40BC351B6BF98C31E15E1CCFF3F34D7592FBC8F1CC026D596A04AC80DC0E3756EA041E0E4BFD21223324848FABF38693FB4F40CB4BFDC4779F43B2610404A537C4BAFC6FDBF2B76F6186E2701C004AB4FAF6DA509C0A8C71E29238909C0F99224174021ECBFC2878F1748920BC06B8D5256B5D810C0587D25AB3661E53F96DCA726D207F7BF117B45C15D97F73FAFA94A9F5E90A4BF08D1FEA0E51E0CC0F076979E804A04C0384056A0C52FECBF5B368840F54BD43FD0CD979F341F0D4060C694094DF7F5BF2E7F840036B50140DC354A45F4B205405CD4635229A6F1BFBAE3D113A39113400643F358C9AE1240D83AD2A9B0FCE03F1CF52D0FFAE30E40413F29A153C803400332C048F17814403A4A82D2A55DDB3FAB17AACCF778D33F5A20B455594000C04E18F2EC00F5084010B4D1622327EE3FA8931B23191CF3BFA8E410460D910240DAEF574D966D07C0EC21E6F9941E0EC0BFEA62C65350E73F02B616609D79C3BF4281D8347A87E33F8409A924CC5303401D08C21019AE11C048ACA73CD0B2F13F77A5F67080087A3FB0E4E7790F7F01C0B342AF141C3301C0750845C56A07CE3F74D48C35A4D4C83F90E40DE866B6E3BF09A5EE4C8C4D0E40FF269322898CE23FBCCE104F137BFEBF44180DF57A580D4050BF2399556108405E4730B3B2090BC0258D38E7CA50F43FA2743EC9583200400AC312E612AC00C0836B53C7DE071C4038EA062CC7D9FABF1DEFFB2B75700240127E620478490840FD7BC0521EDD0DC07E60F38FFEA5FABFCC7B09F67D1FFBBF52C2C616C602E43F2560916D2829F8BF72F8ACDFF9460F408AFE1DC6310809C07638914A8C7C02C065913ED34423F7BF81702A07287FFABFC330AD348E571D4022F6EDF74EBB03406E36080A5E63E4BF8285382314690EC09A6299EE2083EA3F968DAB51F096FE3FB6A04C426E911840C64788C750A9E2BF4FE4E30767C00940878BC65097FD09C0785DA0E6037EF1BF7871D933AFB607409B0472CFF832EABF78155E01525715C0D339F097B3220F40FC2F5323450F16C092DBAFBCF5E4FDBF15DEB8994AACF5BFC012C5780FBDED3F2694A9140BB90BC0080DF58B9441DF3F6A8B2DE1E15F11C0D0B7FBE2BC58F53F3A5C8B662E4AFE3F315BD34B1148F1BF8ED573844F9EDD3F59DB3FF22B94FEBF536AA0025DF6D33FD4CE64EEC03F0940FA46535739DA80BF0AB8203041FCE83F5DE3D333417C1340C8712AC929F6F13FEE41130E6554F83F874A8FB2C446D0BFA7A0F19A7142E43F58B1ED5CD8FEF1BF41DBDC5777B20BC086EE30C4D90BFCBF49EAD69E8646E53FB89B086BE8B1F9BFF09B06B93DA8FA3F107BA35E284118C09927D213D441FCBFE0C6E45D9BF7E8BF44DF9680D664DFBF143FF2CCC3F016C099ABB5660E2F06C0B679638DBF0AE43F02B6674D0C26F93FEB137B2BC6E8FA3F6208072A7AE806C0AC2890716E0604406D0617EFC1210840FC521FF6403E06C0A0BCCADF973501C0700DF708722DFE3F83B76CF4FE6DF53FEA45235DEDA105C037FDBCEDFC970C40AE3402E725230540F7213306DDCB194094813E40222304C08AD15AC852321EC0E285BC1A1DD70BC03A1C0F64D840E9BF2208ADB1075EE73FBD1BB51D753F11409D59EB76E0B7D73FCA3F39DD9C41EC3F0E7EC5A37AC111C0DCA985BF2D3AFFBF73994600E2F2D0BFD33F089789F6913FEAE40E137E00E7BFFEB7C4E56DBA0540441542BEFC820E403E346830722E0EC0565C8E1A1786DEBF4668CFE023200740DE5D1DAE017D114045A0DA00117B204014518E52799103401A32CE563C39EDBF34B0C3801755EABFC05A50F0EACDF03F040B4CAC227405C05A7B27DE341CF1BFD46A07F63DC605C0D18F82F5C14D0DC0738C2C9682D601400E3CA1D86EE4FA3FE64CE0E3600D17C04BEB60E86C5404401027ACC5918F104033F4E8FAD1711240468B7F78A4120F40231A1C75E4DAF7BF80DF1F200B72FE3FDAA67093080502C014FBE3994FF6E03F07E2EB96A3E908C0103EB0DB40DE0640F234D39E1FEBEEBFB5AFCC0054B1F13F0BD22D8AC599E7BF74EB9138C7D1F7BF0A376B37D56C0BC0DB6B05CC442D10C068D37DDEA29AE13F6A30E4C4F2EAF93F90F11474132E024074C40607D16FF03F00D104934A6E0240D09CAE0A03F6DC3F9550C93A67BB0D4030523B08FD92D83F92B5A65B0A9FCB3FF4A2527450FA09C05AD1BC533F92FDBF530C76C77EE104C05A96ECE5FA15F53F744B38319246FC3F6EDBFE21C94BF83F990AD93DBB1902C0FA1AC1477C3220C0803B0617D63F13C0E0DA48CD2BADFA3F2E8502780F0EF7BF44468D19E3070840D810F01B89061840C42EF45363C716C016EF09E48BA905408928673E1F82F13F0D482EBEA53BF43F0A2A4DE8C36DF83FBDFCCD1B186CF53FD8D9784BAB4009C0B549B4D31EFB07C0F3578A7A1F109A3F38655878EDA0DDBF4A3D14F8D8FDE73FE9942F86F30BF3BF66AB3716BAF4E9BF278CBE782940FB3FD89688A94E3707C049F5A71481819D3F272E64C8C80C04C0C8500D91BBE01340EEBEC1B901D60C40F542BDE43072F13FCE7C0A2B26D81D4086BA4ECBB58002C02E06562D27570140209F975A6E3406C0AF56F6FD5AE80C40B0188E2953F20FC03C6DF1310E13FABFDCC1101FF2A9E33F178004FFB832B9BFA23D1D530268FC3FED0ED3216F1D0F4054B48D6A8512FDBF82C3770EC89F00C012C553464973F03FD252DF07E2F6F03F8DD1D18CA823B03FEFA53ACCE5A8FA3F452820CD2E6FD73F206B8DC75C90FABF9AF38A24D1DAFD3F464A72D99B6EF33FEC45239076BCFBBF07A81FB845C5ECBF8CBF5AD7F6EBF63FB4521BF4D080C23F7206E52A1EC6E23F68393F74CB36DDBFB0A190959F0A194040258F6F64C9F9BF597D6E35F47EF0BFCED5869F193F0640C88D6523801219C00C0197E95457EE3F60FA368DD497F1BF3E95A909A7CF13C01F7712897EB60D40968F4081AD83BCBF7D20DD6186AAF13FB286E3DECFBCE03F252D4B06B2660940CCBB379141C30CC0A5889D1B79721040C9D283378EDDE33F09F746B0238D0540A2A82B134F42EB3F51FCFA46683105C00F311955B54514C0D70936FACF2919405E0553F8CA7B01C0FE86012165050840F606B5D29F17FFBF3E5D05BC5D41CBBFD2BBBF4FFC9E0E40F4054C332237FC3F8F1817D95CA804403A16BAF9790BF83F66673F15F28ADD3F717E1019853014C005F1846D724411C05ECB2B34033BDFBFBCA017B434070A40A0DBA1F36D12FBBF4A2DBBDE774DF0BF8C1A7261EBFE08C034D41BAC16EEFB3F11A2E8DF9D75ECBFE0B96C75F6D109407D97ADCACF7206C0C086940DEAA5FC3FC09E23801ED51940E832E0321386F3BF608153D12BF6FBBFE4B647F5718506407898BF5C408A11C0B8E194753DF812C0B81CAE091BC2E5BFDD8B93B8E5BE0BC0D694BB6D5F4DFB3FDBD80C18D03CFDBF21D2B66A07DC00400869A70DAA9EFABFA9411D362012F4BF287480227E6F02C0AE33D713E189F13FB23449FEE8060EC0858252BBED9E86BF2F27E030A843FFBFDDF9063A8E23114046F0D18CDFDBFDBF62C03024393DC0BFF18963FD9444F7BF03974E86708907404E2B7944FFE1A43F19EFF91249670740B1FDCC4FAA1311C004260FB21B62FBBF34CC827D767511C0C0D52D39871CF33FBEA2B1DF45A9F0BF166C4F0189B2D53FC2A3759CBE29F33FCECE937071F902400CF659308632EDBF3CF8CA199DD9ED3FA44F7D195FCD1FC080EA7C4CE13B04C0CE27C9AD1DE2E4BF788C2FEFEA26FB3FA611015E7DF81140DE6485F16EE40240A731736A084FF03FD59CF5A12F5B01C0C87FF8F11BF5FA3F2CCA402C94290240C011D12674850640388AFF394F49DEBF1C0118DEF26B1640D2349C59B725E83FB4C8EF00B31800C07624CAB38E8F0040C027F2782DB3FBBF8704026D660B11C016A6A6FD94C31440BD82EAF6591FEABFBAB767F99C8F10C0098E6D513BD406C015377FE3AA1B1040AFC0E37EA485EE3F029994A5E0F800C043A264E3F6C806404CC3B69A1F1E0540E752E867A18D1540E660069E033809C02EE1D3C972E0FF3F53F73BBE3FE30140AEE56FC56A01CA3F583D49B45D290540CBBF78041F8CDFBF971043ECF5D307C0F48ACC2FADC1FD3FC692E532F24813C04FD22F048E7AF33F57406E95722A14C0BEBA478677F10840B63391EBDA98FB3FFFB6E21268B0F03FAEA478B4164F02407E57F72C74C101C032C7BF1E37A4F53FF71D5AA58FA80440D67E05817990FF3F04608204AC3FE9BF46956CB025A4D83FCC84EE1ACCD5FDBF2C5DBC7ED46FF63F7B1D787043A807407E60593875DC08C0981F3C4B38540240F75297C035BBEBBF91FBD3B4D1ED08C0038C1FBD509609C09F32C9D5FA6AE53F7E85E3A40BACEA3F38A19305036FF63F12F662169D99F2BFA485C86A0D2DE0BF0A8139EDEA98F13F"> : tensor<20x20xf64>
    %cst_0 = stablehlo.constant dense<"0x5A62AF4DCA210B40E85CFF0B74F20FC01C9F8EEFE13AFC3F452421B04BD104406E4482954B2E0940931B2CF1E297E7BFA04931AA26A30440F2B0FCBF09DB034019FE9643610AE6BF1F7D8BBF5CBE0640B606AAC91B80C33F3BECF6C6CB79FABF2791270861710BC0A0D2C6429A0713408A88EE0390B6D8BF1279AFA2B8D10B4098F6E5CFE0650D40305BDAC214A5E03FAA5EC9109E1CFCBF257D1FD7B46CFB3F9C34CD28CFD40840B8FB321DFD220440CA26C9AB523508C0EC10C3F56148F73FC67D56FB8CF1DEBF6A0990B9791FF23F4C239CB669A9E0BF6A42DA696384184091E4467DF16CBCBFC7A0976789D0E2BF9251C6DE0549D53F52D97B5EDC09E33F30ABC013DD1A10407C5167888A9210C0486B0252198505C06754ADE3927C0240398D644F58E70340004FB6E3A5AA12C0325F380582BEC03F5EFB23CE97E30AC041CFDB019DECE73FF1866CA6AF0522C01C61ED0E017BF23F811BA6642BE9F03FA08F656B94E1E1BFE699C3A755720EC05C4326D94BFDFE3FEB9A7A4926D0EF3F0F59CE509770F7BF3EBC70B320E00AC0AF949E932C3A0DC01B90DC45E057FB3F011998B5F78614C048BE29EEF1071A407FE01DEA400509C065CD828F0448EABFE8C85D029C6D0CC08E65F1C0C9B81540E6BF4EB8A58BF6BFF460DF649A57FCBF0EE0AD46E97704C06EA6151D83C2134026E065F10787BB3F30B953223C0C05408F2A7A7908F407408AAF00A055310EC0B14AD9838A18104058D6A6330BD7EFBFBE9BADC919C211407269572284B1F8BFFE67A723EAA30BC07D6F93F2547FE9BFD0C2AB69A07B02C0B7BA97D05FE31BC09884D6230AE606400EFB5AF3A79FF93F1E00F78AE7B102C000CF7BFEEE6115C0EBDC90F60A960E4054232405B41DFA3FE0237C0ACBA8EF3FC696D03E263305C04F9444EFCE07FBBFCBD6E2A4E6C3DFBF8A2971D7347AE93FE9DFE5A8AB0ABC3FFE29794F2C530040F23CE6E1803F16C0BC2F1A75B76AD03F44763D6064A7F63FEFD5AC00FDA80AC035202187BA3FF23FC1AFF62EBC790140C2A0E80F2971E8BFB235F2A31F53F13FD267350ACE220F409C731603F65E03C03C1EA7BBED4B03401524C0F123DAACBF5C8808C9B826F6BF9E91167A8B920F4097E2804F35B4E1BF9E80A7AE8770EEBF3445256BBFE0E43F0C8F304EBA2BECBFA24FD59C4C35DCBF7926D84EA9AF214054D5F3EC217205C02499547E1831EC3F4AE1D23F2FA7B33F9D284B841BCDE3BF14490846317EECBF248BAE182EE70EC0BABEBC146E9C0C40DBE0273994C6F83FADAF1709294512C0D9EF9483BE11AEBF46C6442C508CC33FBC8845775798E33F714EB9B1F69C0D40584345D976140D40FDDD731159EB03C02A4C2E3C5EFDF23FD77898FA68A90440AA3BDF1E4028D03F42F7184414AD084015D24F83CDC903C0E28523D1AB9815C094E3F2CFEE96D73F319C967DEA51FB3F0A852841CC79ED3F19731B2C3B0C16C0B5CC7EF8C9EAE83FA7CA76344FC4F2BFD0281A3ABDE4FB3F3772D146FB8B02C0CE7AF1D7319B0E408CBA61D6EE9D19C0C0B365384C9BF83F48184791A654FBBF58F27EBEA2FEE83F93E73CDD9B89F5BFFC2EE280E85D23C086EE4A2BF37ABEBF739FA6495FF7F23FD25D4F9EB19B0040EFA2FA8A3298D03F099BE0F6BDAAF7BFD853CBDD300E03400DE51408D2CCF23F6D097BD91A85F73FCBA8F2F22F4CC5BFE8722904F0E50440B6AD8A6109B0F43F98F603DBA1E207404CFA3E407F4B03C020ED896CC4EA08C05FD5628DE11DE8BFB1EC957028C9184000D460DA8DEC09C04340C94F2BAAFEBF84A39189F4DAE33FDF716C205EFF03C096EAE789A846F8BF8B131F75308112C0F324AEF456F300C0743B795F22F6E73F7C55D156E34CF3BF92EE1E318605E7BF4F3C3E97311E0640BB86A42A0032D1BFD27145F7A08CE7BFDC66305797EEED3FB8B4FE67D9E1D1BFAC0875430E44F7BF8E94F8D7EB220CC000D0225CD634F7BF921AAB2CCE3C0AC02710BC4D7530F5BF71F2B9385E2811C0AA722EDAB2D115401EEF3A0E08F2F33F7CCFCE50C5A212404452B78FF795DCBF62BB116D05A5D2BF5781B76DD3B8E33F8749847A3BF01940C880F577BBB6E93F8C0CDEA7562BD13F6678893F0E04E43F382FE346FC960A40B16CDC2F5632DDBF900C3995A1BEDF3F2CB531875FA4F33FDA1C9B07C37F134080F921A938C40F40765071980678FBBFC3C80EFED104164072D994A066CDFD3FD7E323A933CA02C0EB3BB21781F41240D7869D9C08FD00C0F1B516A9D17014C0B6226DFF247206406A89CA88BF2CF0BFAA647A3CB59D00405A79A7CBF712EA3F501850BBA2E2F8BF47B68EADE422F1BFE1C7EA387E840B40967E8F57213E0440B28D6491745EE23F64249BE381411A40392D62516119F33FA6F6DCE85C3904C040817C80E27608C081C82B40FE69E83F44D98D9507C9F43F8B8A96E7274CF3BF3CD638541423F83F62FACBEEF02D0C409552D704A40D1EC0A2DB1A148E5FFC3F5CD4774145F4FDBFD84BD17EC09212C0130B60F1F184F5BFF0C45A61194BF0BF7649255E3A99034048E6F146E1A0EC3F3F2623E5385900C062D5CE4E52CBF93F1A8D11E9B377C6BF424FB5C60E9CD83F259AB6A2C755E3BF1F5838D7BC1401C0A210DA1353A516407E77A388FE1613409AD27E03465812C0FB119A4BA24C0640B680088C18F2FE3FFC31A1FDDDECE4BFF5FFEE0E29900540F87F0AF35CD10B40605A56CF2325EBBFDCA664E80744FB3FB248C1040A2F00C060909BE4177F0540AC118BF37FBFF2BF8152486A7074F93F22D0D944C511DE3F8D37720A97DDFFBF71DE661AA689FD3FACE6FEBBCC06D63F3C592577772710C078D63D6983F8E7BFA211E22C8E430FC0B054E937A4F8E13F38D9C8DB926A0540EDFC49AC4696E0BF5F031007AC55FBBFCA8A12291CF6F9BF6877A0B80649CE3FD3DB723E35AEE53FE0D2CD7CA6A3E4BF4662AD0A0E4D18405CC96179ED43F23F8E4B3338A077FDBF78328763D7C305C0A294FC80738CF0BF75004FBEF8F604C02D1898D54011F9BF8EEBFF775C94FC3F20E734D8F36BFDBFC309474C571FBDBFED9E75B58E4B1240901AEAF4BCA00140C04806B93BCCEB3F64114631F1F5E3BF1FFB9BE97AE7144059F0020F8CA50E40B0D9CD7811C814C061A53C3441C2A83FCCBC0FE57B5D1A4050052A3469BD09C09DA20CF63D12F7BF5C7CF9C10A76FC3FFC8E0B48F846B23FF4987C61873B1BC036C7AA3D5F5FE4BFE3A7F33C7BB101C0003792B0E4DDE0BF9C061F8BB6BEF03F9FE81CFC0E42D0BF4F50DFEFDE8FC53F7D32FF170EC4F43F284B55EAAF281A40CFCF5472FF30F6BF26A22A5FFE8D07404D353F607697EE3FE2F45C0715D60140C09EB789BCF4064012E0D2488A630F40E3630C9F5877044050F504A8DA99F0BFF85F0F5AE667F8BF24AA0548884009403AC65EF947D214C08EC8E79E8746F03FBEAACC1FB07A044098D9BE1B37FC084070D426DC7D720BC028E007F209ECF13FDE4C89F43E5B0AC0E47C0A837AD8074077854D6502299C3FD4B007EEE348FCBF74E7F1D7411FE4BF04EE3A0734F00040229C49691C00FDBF4C5A1D6DD8F1FDBF56A8F2E86AD10A4080DA93E1B9951EC0ADF3040E33D809C07C9AA96C6B95DCBF0AC3139C0E1FF4BF444518232756014074CE9253A08E1840C841B5C2A3710B404E5CC8582E680540BE20E73EE9351740D0588D18790B05C032C951BC22D5114034B16188A89F044022F4D2CCEBD814C0218C5B6E1B13F8BF0B30B3D2F7861440EE5E5B742E5AED3F48B2B2EA26C4CBBFF27A089BCB84EA3FE576F04FDB090440ACAF68F4E6D50E40F074462F191903409C5FA01EABAF18C0A0AAB6C7BA03F7BF5AFE9688D6FBEA3F402D45B5A9C71640FA8E8803A1EE1140F042EC61A0A594BF3D689ECAE98916C0EE7706B9D855FF3FEB1D3DF3D73DDDBFB9BBABA5D73D02C0DED0EACB516EFB3FCE9B6F5CE603094090B00E39E4FFFD3FF07BEFA859D10C40FEBEFC99AB1117C0BE97F19B50A0DE3FDA7A0715E01AF93F5485932132D70D40B2EA6707B884F03F1F0B8C98F36CC43FCE56CF00432211C002BFC91EF6B7FABFEAC65AAB8650D73FE62C39AA5D5E0240F8A7F1322C98A6BF84439238723FF03F1023A5667A7101400991215371320440D7C29D864DC711C0E8F2EED91D42E2BF9C9E9A67985D1140306FE58434B5E63FE4D0EB0E6AE6E5BF668A6FC461C6DD3F45AC6738C4F7C83FCCAD9818CB53D3BF4024C99263D0AABFF78704D8B49CF5BF50444D2A9BD40D40706D87F31145EABF460F3FA14333DABF6D0A10551A0F18C010F408CA0D33D33F089FA30D5FE6F6BF271FCE58D1240140CE85A04028D5D0BFDEF1ED038683C8BF4DB64994BCE30640E627EFB72A53F4BF9CEF9374A8B2EF3FA20BD2E47E5E04C0A744074A5616D4BF8FDC3F9CFA750AC03957527610CDF0BFC23C29BEFB730EC000C2DD922656D63FAC20BE0B41CD03403252CC68D6C90740"> : tensor<20x20xf64>
    return %cst, %cst_0 : tensor<20x20xf64>, tensor<20x20xf64>
  }
  func.func private @expected() -> (tensor<20x20xf64> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x993B0CA3AFE7B83F2BE4524FF09E024069C0A57F5AAEF23F14F4A3D9525DCBBFEAADF52B3C5B9CBF2AC7CA0DFBD0FE3FBF04BB5EF395F3BF73C5301AEA72EFBFD7E2819E0B1103C0B3BED51010C4E0BFB226C0AB4264DEBF233837E1395BFF3F73108FE0F82705C06B8110CCCE19DBBF26D82D0CFD0CFBBF0C0D4C4F96C3E7BFE49F89260D0ECEBFA5C900926CBCF6BF0AE328F8D174FFBF7B788FC283C9D73F0FD3F8AB49CADBBF181484C5EAF4E03F1399F1F8CC0609C0C9A1848E4EDAF2BF87B9E2DB8425FCBF6E39EE6D9C26E5BF1CB9E46095C1044057749DF15326E13F00CFA1478B6CFABF21ADB6BB6C49FD3FDFABBD6E3D2EF73F52018084EF37F1BF25B5EF23F23AEC3F62EED0A40A5F02405E227538F4920740B81B67E51381F03F71D8DE93F808E93F9876D87B0F7B0240C068163CEB61F43F2961A96518690840763D17B5867DF3BFDC8283776A770640F14D14B0CFE5E53FD9E467057515EBBF981FC3FDC1E9FC3F82FE58CACBE203C04DAECFC1D487F1BFBFA6534BD43CE43F31B83C000B4E08C0CEBBA6B5F2B10740DDC2EB63697504403215E6D3D13AF3BFAEF4EA82306F07406C1AD5425700503F1775CEC1344004C07B42F75299F8FEBF3B8D964BF89A084038A584783948A23F4310BCF6EDD505C0222CCC5CDA100040265E078BB25907401D9F5F2F688ED7BFF2885D54F2A9F83FAE9A6419D779EB3F533A8DD4F010EBBF9D0FF88C548906406E8094EF64D5DD3F22BA8342402100C0E6F96832F118F03FCF2B114DD28302C0F92A0C771D6D0440DBBDC5AA4D3DFD3FEA0C4397010001C03967FD2ABE4107C0E612CCD9391CE1BF0CC7214B41D3D73FE978D14F118B04C096B9B2A2B9140440ABEACD159FF2E5BF6ED09BC41196EEBFEFBBCC7FB210EFBFA297B08413AA04C0432F246125C1FC3F335240FB5D4FFC3FC4A4FA68B498E5BF2BBC631BFCABF8BF6504D1C0E9AED83FF4E1516BED7B0640D552325E0477F83F97E19CB65401D9BF550716F0FBFC024021AE1EAA10BBF3BF53B729D6ABB2DDBFD6D6C100F72AFD3FB1E2CFC08DB7E4BF5A57C5F30719EEBFB08B8030CC040140526148482F89F2BF5949ED4A7B9DF9BFFBD20AB3D5EF02C0266B5C1D1A9ACD3F642353E170AAFBBF7A0269A8925605403D0EEED74EBFF6BFBC7B8772833B0140EB61C06DEBCAFC3FE191530A1D1DBFBF2229254DE0C30740F82209E9C238F2BF5E4F64BB7E45F53FDE05230DFB3AFC3FE13BCB390E0F09C08AF602578789074017E573E20A00EE3F92125CDDBB12E43F3794F59ACE8F06402D02AEE98FC3FCBFC98B036F7658F53F86255410D927F1BF4D1647213510E8BFE5A58D81CDC1DCBFEAB50E58970B07403151426E24E6EDBF1C4886864C55E23F813EA1828B77F8BFD7BCC8FDD5A3E0BF0EA96C8536B006C04FDE400A6C6808C04B463290191BF8BF27DEEBB6464DF0BFE9A93449C71BE33FBE83529B12E90640459D3FBDF531F23F89AE3B275C5AFFBF7D436B1760CCEE3F54255F39FECE0140781060C4501CE4BF9F890E24508A06C007D43CF12760EC3F4C160BF822D0034092C5EF9E2EA2F4BF66F1FBE84BE5FE3F7ED3A68B74000740D6C5B707986DF93F2AD03D1A4117F2BFF65B4EF4BFD6F4BFF448A8755CF1F7BF93A735EA423605C02CC43825CE09D33F8104083549E0F43FA9D2B258719CCF3FE4E8020BDB1CFC3F1A4620DE439FF0BF89B76866CC8AEFBFDCCF5625CAA5B6BF027ABC21161309403A48699E775107C0143CBB16A776FD3FB5B4CF93E3A7E13F5339F39D603E02C09AADBE127B2E07C0097D8D01EEBFF53FEDB282D2AEB8004070AAE81CCD0BFC3FCF6B5777E33D054077EFF4388BE005C06DD30718E1A3EABF6BB777CFD766034009E607C38A53FDBFC627108BD99ED7BFCEFFB22501B5FABF52AB241B164EFCBF968508890AC7F23FE805E512BAC4FB3FB59860C35616FDBFA90C32468E2004404DF2B31A2C86FE3F1D40683724830140F720E4CCED63FE3F6C62FB63E17406C05A6E64B4217BD53FFF206A688C0BF1BFB0753A585B00BD3FF3565CFA7D69FBBFBAFF30BAFBC1FA3FEED3899C440CF0BF675E32D78E9EC53F8B35E3312BC3E7BF867F90B9B547F6BF9906ACEDC23EF6BF6117639C8240ECBF3418A264E11A024084AA0049E560F43F876382923E35F13F80B9FF29E195CA3F9F573E64CAD2E03F1A5BC6872C1207403A3A6702D800E33F792365AB9305CA3F18D82AEC586608406B49E74F6239E3BF28E116503D6703C0A2FAC335DE5A05C054CFF0E6851ADC3F6245D11D25B9004048A50CC19333E43FC61CD71C1E9AF3BF6593F726272BFCBF6E44509AF4A2FCBFB1E51AF8DCE2DC3F6EDD6AE0B190E0BF890AA393911CF63F29FFF6D2D7B6E73FD3924F32A7D3F5BF955DCA873193024030EAF99737620640C0545CAA6E72F03FD5C3FA75B2B4EB3F5A891BE4B76E02405249A6F1E5FFF1BFABEA1C910190E6BF28E8F9410B1B09402838CDC9D857D0BFE0955855DF15064016034830002007C085F4B91C90CA04C023E7F7AE9DE000401E983D5E80D4EBBF1C49188C147CA03F63478483EF0902C0745CC5F5131DF43FA98A9C8149E9F93FEA8621384AB5F33F62143F4AF76CFA3F0C61C972B38702C06B309631BD66D73FF66128D24EDBE0BFF33B62FB50CB0340C853FFF3CAC3EEBFEF81CBC2D467E6BF8E48DFDB1C190340056962AD5BB0A2BF4FFF9C587336DE3F013154B28E91FC3F7496A7FF9528EABFC69B7817FFBD02C067A1A5026863D73F18D1585AB03F03408DAA39F84E47A43FE99D8AAE3EBCF43F3573D8149CAD07400BC89BA22770E7BFA390967FE136F63F1BBED3BFB5CB0640FF93DA37AFA8FFBF9CBBCA41DF5207C09FD0C2B8B427F33F26A75199D49EAB3F12C5825AFD5A0240E412E324450B07C0D4ED0B6ABD30FD3F8C788037EDCCF6BFC0A28C1D45A9EFBF395008DE7EC7FC3F4AC369CEF0A1E9BFE44782E5E52DE63FB8006E48ABD304C086548F65BB9500C0985A2D336F7AFD3FA42C5FACFCCA08C09051193FB5380440549607EE263BD23F843CC0BD11C400406A86800F8AA3F9BFDF4B3245A66EE73F28116A284C93D13F93DEE9C44D24F43F8BEB9B6F6E9F0140B334048FAF06DEBFEC797A3AAF8DEDBFE5327852C11602408BBC4B6C5DC7F8BFD861A397705BDB3FF7CAA9C33BC904C0DFED6494B9F507C00B6AA35E122CF23F841FD1E03D7CF83F5E6844568A3B06403B4E4BDF4F8BFF3F2C7C2081957C0740EC5402422CCCFABF23D93704C253F5BF2A7788F3FB6700C028A0D30A194EF83F0201F061B053EDBF18646E1EA6C8C3BF8E3CD50B2DD1FFBFA60073691320E13FE965DA7E50FAE7BFC5477396C3EBEE3F25045EEC6AC6E8BF129BD04B3F66DB3F7CF65AE81919F33F21648832263402C09783FBEEA34E02C0285E23B6384EE73F867DD2323E8803C00B540A8487C0F5BFD4D961D1969DD0BFD34C8DA871CEEABFB2891F7CC3700540724925238E55F0BF2538F4028194044066EA29867E4AE0BF619C978F33C8F8BFF3BAF8FF24CD01C015E253B5A1BB0040ABC4DBA740EAF0BF376EDE6B801509C0CC16365D57AD02C0490E0A5F4A05ED3F1F26423DB83707C0044DE17498D108C03BFE49EF78E6FDBF6D442C978298FF3F787D6FDB4545933F1DF491EAA275DC3F8C408FE5D19AECBFD7A66E276A35E2BF017B2AB00BA3E4BF02AE7E5C10B905402D0A0F58185FCDBFAD18BF12AABCC03FD7CAEBE360530740AD3FDFEDC8160140E9948DB5C985C6BF23DF8215DC66E93F459781A7B591F9BF950817F71111F4BFF39C163AD74FD0BFA06CA238018BDA3F1EC382416451F13F087BF10B85350640E05FBD1268330440CDE0109A9133F3BF91C91ABAB968D23F84B074D75700DE3F967BE26C513FF93F8DD2877B627608C0B794753A33C1F33FA634F89801EC0040BD7BD724425903C0B3378C879821EC3F92582AE7472EE0BFB0477FE61980F2BF8C82BB6D54DAEE3FE404D9A3020208C01CA33608A74AF7BFF6FB1D95D016F1BF8D390A816B5BEA3F7339BAEB04DEE73FACC6E1A078EEF7BF707279AE3D700440F8607DC32C140140EB85DB807B0DF83FD4003A38FD1EEEBFC5D2A1ADB17CF93FC6CF15D7D04FF23F011F8080FEC8B73F25A1B426FFE0E93F4432785AC63F08C0906B45C33B29FCBF11C943D424E7D93F665EDC9467CBF6BF2DD59E1FD3A90040073B2F5A10A9F7BFA90B6B0F1022F83F8FABFECAEEE7FB3FA30F46D676EFF93F54C8749AF5D4004047A6A405422EE1BFAA82175B2DEE00406988CC8EF8A5FB3F36E94820E7980640A58C4F57CB51F3BF13357A40CA070740E0BFA6C410EAE6BF6C90B5616319FC3FA7322948E12AFA3F26CC93E10674EABF6D2408AACA9D00409191B66F0400E7BFA950D61D050C02C0FDDFCF3DA5B2FABFF0B7B9CC1489074086488CF0ECC30340413A0A11384F0640783BAAE25777F4BFF30330663CC9C9BFC0825EEE4FACD63F"> : tensor<20x20xf64>
    return %cst : tensor<20x20xf64>
  }
}