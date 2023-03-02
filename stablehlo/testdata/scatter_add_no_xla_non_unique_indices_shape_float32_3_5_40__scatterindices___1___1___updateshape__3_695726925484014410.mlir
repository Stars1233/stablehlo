// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<1> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<3x5x40xf32>, tensor<3x5x2xf32>)
    %2 = call @expected() : () -> tensor<3x5x40xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %5 = stablehlo.add %arg0, %arg1 : tensor<f32>
      stablehlo.return %5 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [2], scatter_dims_to_operand_dims = [2], index_vector_dim = 1>} : (tensor<3x5x40xf32>, tensor<2x1xi32>, tensor<3x5x2xf32>) -> tensor<3x5x40xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<3x5x40xf32>, tensor<3x5x40xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x5x40xf32>, tensor<3x5x2xf32>) {
    %0 = stablehlo.constant dense<"0xD4176DBFC15A983F97E731C0098A2CC097473740118AF93FE8B9933F7EDA08404997AAC0236DFF3F173CCD3FE6A785BD691D2CBFA1C2ABC0666E9E401ABD0E40BF8945BF5F2512C081D5963F47ED283F1ACC4EC0CC94843F26A9B83F87834FC059575D3E1D84DF4077AC03C07A34E2BF741B88404AF117C08973E6BE95FB563FABE08AC0CD366A4095FB8A40982C28C069268CC03A6308BF114E164026EACAC05472B440088932BFCEA2F4C0183697C0866CCDBED6FA0740C44F9B3FB02415C089430940C4B23BBF7D241F403656593F68930240524DDDBF5BAC483FBC8FF73F513701C0DFC2C83FFE09C7BFB78AF83FD47A463EC7A6A3C0034AEF3F1E7B3FC0F84A5BC05EACC0BFA9A9A740388C12C04FA205BF6AA200C031153FC0FE79A7C0891BA7C06261DABED4FE053F4348FD3FBE8F0C3E646F9E3F3F2754C09B3401C0814A7D40B907853F1397123D7C93D83F5482C2BF5179C9BE09520E40A26C12409E443040326A80BFDE739D3F9638F4BF821CB0BFDEFDA33C6D393140095CB540315E5CBF1FD885BFCC0A90BE1520B1C0C82A4440889D8C3F116A76BC91BCA2BF2CD60BBFCFFA97405DF43BC0A58FA93ED6A4D03FD8DFE13F96BCDC3F65F11140ECCA33C0E74BEF3FFF97CC3F05A4103FF1CB2CBF2EC0C43F3A3D14C0F4F314C01EA2C940AFB09540FB5CA440C30F37C0464DB7BE6CB3E1BF615390BF7657D23EBF14C43E54690A40D43E1240740FA44074DD85BFC502833F8182013FCE93B6BED72FB2C04D21673FAB100FC113818640BC03F8BE57A1C5404254004019EC1440DBE1903F6ADF36C0350320402A8C36C07A40BABFF8E98F3E3B0751401260A4BE80D29DBE3A7A953E4D7321C0C0348540E9AC61C0692FBF3E8CC139C05E27DCBF2495AF3FA9704FC0C59727C0F5C39B3FCD22F73D353DF2BF2EC331C085026BBF3C91033F83A34F4098D940C028C3E2BF5E0497BF48B916C0DC86334037AF5AC014068F40836DEA3FD113CB3F9F3E8240D3774B3E7385B6BFFD425AC06599AD3ED38FC33EEF31CDBEB78BCABE2D3224C08657E53E21C190BF038CB3BF4AFDBEBFCB9424C014803ABEEE7CA04078BB00C067B042C0948E46C01AE21CBFA65CC4BF295541C0A51AD8BF055B49C00573A33FA43074401B3D673FC1E88A40E56BD43ED5B9ED3F57A826C121AAF1BFDA12AFC057626C3FEF82BFC00A629F4070F71340307096BFE9C737BDA9DA1440318B4D40546A9C40E25CB2400B4C863FAA731C40BC6198BFCBD360C048B9E9BF8BAC2F40107B90401C996EBFA8F6E1BF104EA5C0C7B4B2BF5944CBC07783AC4093F58C3F4D2C0E3C153048BF1C842D404A1714400EEEC5C065B349C00BFA893F28110740A5838040005D40BE0652AC40E3B4893F92CA57BDC344913F5E440FC0DE9453C0E53166C03C64F23FD825AC40FC9F76406E9B104167581940C6C56640F375CBBE88F6BE3F5792293E4AEAD7C049FFE1C0F73207C0049ABDC034DCA5BFCDD389C022730BC007EB34BF86F945C0CF082BC0E2CF88C09782B5403C51DEBE1DB2D23FAC053240E468AC40B5215EC0F0DA9CC0A87EA2C02E4E9AC0064843BE3C6070C027D627BF394E80BF76F169C054E517C01A06694008FD0CBDF252B9BF139FFE3F881CBD3F40BFC13ECC50313F39CD1EC092E20E40B0BD4740AB4497C0C78A1EBFE50D1DC0A8B584C06BCECFBFCCF19940995A8EBF0EC80940F6B189BDD70E4F4024C8963FDB38C33F2409B240FA7209402A094940CB708ABE0AFE41C0A51683C0A4DA984021E063404FEF72BF96C951C0D0BC77BE17A58DC09CCDA4BF1CE42C4004E27BC013BB9CBFB482773DF7E0053ED60311BC9050FD3FD7B404400465BCBEB761C440F72A8FBE78B3CDBF25BE9A3E0479AB40B09A524043409F3F4B9B0D3E0A5C60BF47B030403D6B8EC092987B3F4E447940B0EC7C407BAC983FC61ABEBFB3AB8BBF756A113EB0C403C1A10CA73F2D3C3C4008FFDD3F720E1FC04DE095400AC04ABF56F217403FEFC5BF51E8EE3FF1E6ECBFB14AD03FB1CFA53E57673E40910996401904E33F054D513E5C6E37C09D64244070D199BFF192313FEB8AC03F736E583FA791EFBFB8F9393E0D608540AEBC5DC07AE72ABE675F20BE3B3B5C4067493DBF6832873F74EECE3F0FE4A23F5EE642BFE53127BFC7DD3E3F8FD94D3F5E840EC16D2A81C0B052654014B6324063E3923F3C7FBC3FFE70BC400E6A72BF81D389BF5824B53F4753FE4035340F41CEF81ABF16DB06BDAF7E9C40D6A2BBC0A3ED0A40FE0C0F40B925C7BF66B06840718BF1BF4656C73FB349C3BEC9AB0BC0E8343D400D4C21401011E43F7FF0FA3F01E3C9BF7BEA1BBD8773364017D469C01C8683BEB3CC514046D2D9405342D33F8E662AC172784CBF052FA3C0774F3FC070C20B408CC6C93F1B93D9BF61406EC0B3F248BE0B732540A487B83FDDCA67BF7F35BBC0516D7BC0004A8BBF96F29CC0FB062E3FF2170F400D70493F46CB97BFDD29E3BEE7887AC0E163C83EF00C52BEC8ED20BFE4D1A8BA81F6F93F2FF99C4044F41BC0F29B16C0B31487C0AC900340ECDE803FD7C456BFBBDDE1BEE505814054B801BF10D076C00FC389BFC6E9A9409F9834C0831CA6C07388A43F4FAD30407A0B80C071F18640FB79DFBFB08231C0E4A999C0B0840E401B52C9BFAAB197BEC5CF934094E337400616423F5D960EC0CDC42A405514D8BF484F34C0F368B5C0A5504840B45D47C084FB6E40BACB833FC10FE33FDAE47EC0F9297D3FA7D7AD3F74618740156538C0702639C00FF48C3FD765FB3FB25CBA404B3E163F06DDF1BFAF0C51BF0B4C2C40DC71AEC02CAAB93FDD7FA5C0AD2B8740C998764028872440F54D1C4094A81140654A0740D6884540FC435C401E5B0B3FA6E911C0CF5554BFE1C24ABFE812B9BF1F47E1BF79112E3F442FBB3F642DF4BFEC08B0BF6FD263BFCD4692BFA02BDABF9C259540E230064061F5F8BE79BBC03F4BA7EA3EAAF08A3F5800EDBD33E04CBF56111D3F53E5BB406E1669C0648DD93EFD56DB3ED34D7A3F7BBAD7BEC729B8403F500C407FE991C08DEF6DC043E423404474CCBFA271D2BF3F112CBF215960C019FDDBBFF9B6BFC0AD6C72C0598177C04CCDB9BF7D5D0B3E9CA7D6BFF4FB7EC05DE04DBED80FCDBF6667CCBF294F3B3F34A05C3F633660C0FFDDF3BF8304D13E8B93073F1F555ABFD17255C092DA88406E449040F64DBFBF56C11140C380F3BF3857453F461E7A3F8E4BD53FFC41B0BF432400406DFF15C0663E76400AFEB33EDD612440E56E8ABF1A6EDA3FABAD09C1A6A38C401F3903BF49C4C6BE4AAA5A4032E50AC081372740DE2C8540B9C53440C54F553F4BF11C3F4F693E40F1732FC05B933140B92A6540"> : tensor<3x5x40xf32>
    %1 = stablehlo.constant dense<[[[-1.49375927, -5.0229907], [-1.38911653, -0.451818764], [3.29535365, 3.16868114], [3.45206261, -3.22471356], [1.37369645, -0.457094878]], [[-2.96465063, 5.68866348], [-2.04979587, 1.01570153], [-2.63172889, -2.87656665], [-2.09478188, 4.19098473], [2.16930294, 2.5884192]], [[0.876816213, -3.36585474], [-0.436560184, 2.90581703], [-0.649345815, 5.46303034], [0.132307619, 1.05411649], [-1.99724877, 0.847365736]]]> : tensor<3x5x2xf32>
    return %0, %1 : tensor<3x5x40xf32>, tensor<3x5x2xf32>
  }
  func.func private @expected() -> tensor<3x5x40xf32> {
    %0 = stablehlo.constant dense<"0xD4176DBF8772AAC097E731C0098A2CC097473740118AF93FE8B9933F7EDA08404997AAC0236DFF3F173CCD3FE6A785BD691D2CBFA1C2ABC0666E9E401ABD0E40BF8945BF5F2512C081D5963F47ED283F1ACC4EC0CC94843F26A9B83F87834FC059575D3E1D84DF4077AC03C07A34E2BF741B88404AF117C08973E6BE95FB563FABE08AC0CD366A4095FB8A40982C28C069268CC03A6308BF114E164026EACAC05472B440247422C0CEA2F4C0183697C0866CCDBED6FA0740C44F9B3FB02415C089430940C4B23BBF7D241F403656593F68930240524DDDBF5BAC483FBC8FF73F513701C0DFC2C83FFE09C7BFB78AF83FD47A463EC7A6A3C0034AEF3F1E7B3FC0F84A5BC05EACC0BFA9A9A740388C12C04FA205BF6AA200C031153FC0FE79A7C0891BA7C06261DABED4FE053F4348FD3FBE8F0C3E646F9E3F3F2754C09B3401C0814A7D404E1BF0401397123D7C93D83F5482C2BF5179C9BE09520E40A26C12409E443040326A80BFDE739D3F9638F4BF821CB0BFDEFDA33C6D393140095CB540315E5CBF1FD885BFCC0A90BE1520B1C0C82A4440889D8C3F116A76BC91BCA2BF2CD60BBFCFFA97405DF43BC0A58FA93ED6A4D03FD8DFE13F96BCDC3F65F11140ECCA33C0E74BEF3FFF97CC3F05A4103FF1CB2CBF2EC0C43F3A3D14C0F4F314C01EA2C94022F79C40FB5CA440C30F37C0464DB7BE6CB3E1BF615390BF7657D23EBF14C43E54690A40D43E1240740FA44074DD85BFC502833F8182013FCE93B6BED72FB2C04D21673FAB100FC113818640BC03F8BE57A1C5404254004019EC1440DBE1903F6ADF36C0350320402A8C36C07A40BABFF8E98F3E3B0751401260A4BE80D29DBE3A7A953E4D7321C0C0348540E9AC61C0692FBF3E8CC139C05E27DCBF2495AF3F0FC714C0C59727C0F5C39B3FCD22F73D353DF2BF2EC331C085026BBF3C91033F83A34F4098D940C028C3E2BF5E0497BF48B916C0DC86334037AF5AC014068F40836DEA3FD113CB3F9F3E8240D3774B3E7385B6BFFD425AC06599AD3ED38FC33EEF31CDBEB78BCABE2D3224C08657E53E21C190BF038CB3BF4AFDBEBFCB9424C014803ABEEE7CA04078BB00C067B042C0948E46C01AE21CBFA65CC4BF295541C0D091843F055B49C00573A33FA43074401B3D673FC1E88A40E56BD43ED5B9ED3F57A826C121AAF1BFDA12AFC057626C3FEF82BFC00A629F4070F71340307096BFE9C737BDA9DA1440318B4D40546A9C40E25CB2400B4C863FAA731C40BC6198BFCBD360C048B9E9BF8BAC2F40107B90401C996EBFA8F6E1BF104EA5C0C7B4B2BF5944CBC07783AC4093F58C3F4D2C0E3C153048BF1C842D404A1714400EEEC5C000F185C00BFA893F28110740A5838040005D40BE0652AC40E3B4893F92CA57BDC344913F5E440FC0DE9453C0E53166C03C64F23FD825AC40FC9F76406E9B104167581940C6C56640F375CBBE88F6BE3F5792293E4AEAD7C049FFE1C0F73207C0049ABDC034DCA5BFCDD389C022730BC007EB34BF86F945C0CF082BC0E2CF88C09782B5403C51DEBE1DB2D23FAC053240E468AC40B5215EC0F0DA9CC0A87EA2C0124925C1064843BE3C6070C027D627BF394E80BF76F169C054E517C01A06694008FD0CBDF252B9BF139FFE3F881CBD3F40BFC13ECC50313F39CD1EC092E20E40B0BD4740AB4497C0C78A1EBFE50D1DC0A8B584C06BCECFBFCCF19940995A8EBF0EC80940F6B189BDD70E4F4024C8963FDB38C33F2409B240FA7209402A094940CB708ABE0AFE41C0A51683C0A4DA984021E063404FEF72BF96C951C0D0BC77BEFE2115C09CCDA4BF1CE42C4004E27BC013BB9CBFB482773DF7E0053ED60311BC9050FD3FD7B404400465BCBEB761C440F72A8FBE78B3CDBF25BE9A3E0479AB40B09A524043409F3F4B9B0D3E0A5C60BF47B030403D6B8EC092987B3F4E447940B0EC7C407BAC983FC61ABEBFB3AB8BBF756A113EB0C403C1A10CA73F2D3C3C4008FFDD3F720E1FC04DE095400AC04ABF56F217403FEFC5BF51E8EE3FF1E6ECBFEE51CC40B1CFA53E57673E40910996401904E33F054D513E5C6E37C09D64244070D199BFF192313FEB8AC03F736E583FA791EFBFB8F9393E0D608540AEBC5DC07AE72ABE675F20BE3B3B5C4067493DBF6832873F74EECE3F0FE4A23F5EE642BFE53127BFC7DD3E3F8FD94D3F5E840EC16D2A81C0B052654014B6324063E3923F3C7FBC3FFE70BC400E6A72BF81D389BF5824B53F4753FE4035340F41CEF81ABFD46721C0AF7E9C40D6A2BBC0A3ED0A40FE0C0F40B925C7BF66B06840718BF1BF4656C73FB349C3BEC9AB0BC0E8343D400D4C21401011E43F7FF0FA3F01E3C9BF7BEA1BBD8773364017D469C01C8683BEB3CC514046D2D9405342D33F8E662AC172784CBF052FA3C0774F3FC070C20B408CC6C93F1B93D9BF61406EC0B3F248BE0B732540A487B83FDDCA67BF7F35BBC0516D7BC0004A8BBF96F29CC0FB062E3F209096400D70493F46CB97BFDD29E3BEE7887AC0E163C83EF00C52BEC8ED20BFE4D1A8BA81F6F93F2FF99C4044F41BC0F29B16C0B31487C0AC900340ECDE803FD7C456BFBBDDE1BEE505814054B801BF10D076C00FC389BFC6E9A9409F9834C0831CA6C07388A43F4FAD30407A0B80C071F18640FB79DFBFB08231C0E4A999C0B0840E401B52C9BFAAB197BEC5CF934094E337400616423F5D960EC0CDC42A403E094840484F34C0F368B5C0A5504840B45D47C084FB6E40BACB833FC10FE33FDAE47EC0F9297D3FA7D7AD3F74618740156538C0702639C00FF48C3FD765FB3FB25CBA404B3E163F06DDF1BFAF0C51BF0B4C2C40DC71AEC02CAAB93FDD7FA5C0AD2B8740C998764028872440F54D1C4094A81140654A0740D6884540FC435C401E5B0B3FA6E911C0CF5554BFE1C24ABFE812B9BF1F47E1BF79112E3F442FBB3F4AA138BFEC08B0BF6FD263BFCD4692BFA02BDABF9C259540E230064061F5F8BE79BBC03F4BA7EA3EAAF08A3F5800EDBD33E04CBF56111D3F53E5BB406E1669C0648DD93EFD56DB3ED34D7A3F7BBAD7BEC729B8403F500C407FE991C08DEF6DC043E423404474CCBFA271D2BF3F112CBF215960C019FDDBBFF9B6BFC0AD6C72C0598177C04CCDB9BF7D5D0B3E9CA7D6BFF4FB7EC05DE04DBED80FCDBF6667CCBF241FD6BE34A05C3F633660C0FFDDF3BF8304D13E8B93073F1F555ABFD17255C092DA88406E449040F64DBFBF56C11140C380F3BF3857453F461E7A3F8E4BD53FFC41B0BF432400406DFF15C0663E76400AFEB33EDD612440E56E8ABF1A6EDA3FABAD09C1A6A38C401F3903BF49C4C6BE4AAA5A4032E50AC081372740DE2C8540B9C53440C54F553F4BF11C3F4F693E40F1732FC05B933140B92A6540"> : tensor<3x5x40xf32>
    return %0 : tensor<3x5x40xf32>
  }
}
