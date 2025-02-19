unit RPFood.Entity.Classes;

interface

uses
  RPFood.Entity.ADMIN.Usuario,
  RPFood.Entity.Bairro,
  RPFood.Entity.Categoria,
  RPFood.Entity.Cliente,
  RPFood.Entity.Empresa,
  RPFood.Entity.Endereco,
  RPFood.Entity.FormaPagamento,
  RPFood.Entity.Opcional,
  RPFood.Entity.Pedido,
  RPFood.Entity.Venda,
  RPFood.Entity.VendaEndereco,
  RPFood.Entity.VendaStatusLog,
  RPFood.Entity.Produto,
  RPFood.Entity.ProdutoOpcional,
  RPFood.Entity.RelatorioVendas,
  RPFood.Entity.ConfiguracaoAtendimento,
  RPFood.Entity.TransferenciaImagens,
  RPFood.Entity.ConfiguracaoRPFood,
  RPFood.Entity.Happy_Hour,
  RPFood.Entity.RestricaoVenda;

type
  TRPFoodEntityADMINUsuario             = RPFood.Entity.ADMIN.Usuario.TRPFoodEntityADMINUsuario;
  TRPFoodEntityBairro                   = RPFood.Entity.Bairro.TRPFoodEntityBairro;
  TRPFoodEntityCategoria                = RPFood.Entity.Categoria.TRPFoodEntityCategoria;
  TRPFoodEntityCliente                  = RPFood.Entity.Cliente.TRPFoodEntityCliente;
  TRPFoodEntityClienteEndereco          = RPFood.Entity.Endereco.TRPFoodEntityClienteEndereco;
  TRPFoodEntityEmpresa                  = RPFood.Entity.Empresa.TRPFoodEntityEmpresa;
  TRPFoodEntityEndereco                 = RPFood.Entity.Endereco.TRPFoodEntityEndereco;
  TRPFoodEntityFormaPagamento           = RPFood.Entity.FormaPagamento.TRPFoodEntityFormaPagamento;
  TRPFoodEntityOpcional                 = RPFood.Entity.Opcional.TRPFoodEntityOpcional;
  TRPFoodEntityPedido                   = RPFood.Entity.Pedido.TRPFoodEntityPedido;
  TRPFoodEntityPedidoItem               = RPFood.Entity.Pedido.TRPFoodEntityPedidoItem;
  TRPFoodEntityPedidoItemFracao         = RPFood.Entity.Pedido.TRPFoodEntityPedidoItemFracao;
  TRPFoodEntityPedidoItemOpcional       = RPFood.Entity.Pedido.TRPFoodEntityPedidoItemOpcional;
  TRPFoodEntityProduto                  = RPFood.Entity.Produto.TRPFoodEntityProduto;
  TRPFoodEntityProdutoOpcional          = RPFood.Entity.ProdutoOpcional.TRPFoodEntityProdutoOpcional;
  TRPFoodEntityVenda                    = RPFood.Entity.Venda.TRPFoodEntityVenda;
  TRPFoodEntityVendaEndereco            = RPFood.Entity.VendaEndereco.TRPFoodEntityVendaEndereco;
  TRPFoodEntityVendaStatusLog           = RPFood.Entity.VendaStatusLog.TRPFoodEntityVendaStatusLog;
  TRPFoodEntityVendaItem                = RPFood.Entity.Venda.TRPFoodEntityVendaItem;
  TRPFoodEntityVendaItemOpcional        = RPFood.Entity.Venda.TRPFoodEntityVendaItemOpcional;
  TRPFoodEntityRelatorioVendas          = RPFood.Entity.RelatorioVendas.TRPFoodEntityRelatorioVendas;
  TRPFoodEntityConfiguracaoAtendimento  = RPFood.Entity.ConfiguracaoAtendimento.TRPFoodEntityConfiguracaAtendimento;
  TRPFoodEntityHorarioFuncionamento     = RPFood.Entity.ConfiguracaoAtendimento.TRPFoodEntityHorarioFuncionamento;
  TRPFoodEntityTransferenciaImagens     = RPFood.Entity.TransferenciaImagens.TRPFoodEntityTransferenciaImagens;
  TRPFoodEntityConfiguracaoRPFood       = RPFood.Entity.ConfiguracaoRPFood.TRPFoodEntityConfiguracaoRPFood;
  TRPFoodEntityHappy_Hour               = RPFood.Entity.Happy_Hour.TRPFoodEntityHappy_Hour;
  TRPFoodEntityRestricaoVenda           = RPFood.Entity.RestricaoVenda.TRPFoodEntityRestricaoVenda;
  TRPFoodEntityPromocao                 = RPFood.Entity.Produto.TRPFoodEntityPromocao;

implementation


end.
