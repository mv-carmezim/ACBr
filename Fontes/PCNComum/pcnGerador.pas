////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//              PCN - Projeto Cooperar NFe                                    //
//                                                                            //
//   Descri��o: Classes para gera��o/leitura dos arquivos xml da NFe          //
//                                                                            //
//        site: www.projetocooperar.org/nfe                                   //
//       email: projetocooperar@zipmail.com.br                                //
//       forum: http://br.groups.yahoo.com/group/projeto_cooperar_nfe/        //
//     projeto: http://code.google.com/p/projetocooperar/                     //
//         svn: http://projetocooperar.googlecode.com/svn/trunk/              //
//                                                                            //
// Coordena��o: (c) 2009 - Paulo Casagrande                                   //
//                                                                            //
//      Equipe: Vide o arquivo leiame.txt na pasta raiz do projeto            //
//                                                                            //
// Desenvolvimento                                                            //
//         de Cte: Wiliam Zacarias da Silva Rosa                              //
//                                                                            //
//                                                                            //
//      Vers�o: Vide o arquivo leiame.txt na pasta raiz do projeto            //
//                                                                            //
//     Licen�a: GNU Lesser General Public License (GNU LGPL)                  //
//                                                                            //
//              - Este programa � software livre; voc� pode redistribu�-lo    //
//              e/ou modific�-lo sob os termos da Licen�a P�blica Geral GNU,  //
//              conforme publicada pela Free Software Foundation; tanto a     //
//              vers�o 2 da Licen�a como (a seu crit�rio) qualquer vers�o     //
//              mais nova.                                                    //
//                                                                            //
//              - Este programa � distribu�do na expectativa de ser �til,     //
//              mas SEM QUALQUER GARANTIA; sem mesmo a garantia impl�cita de  //
//              COMERCIALIZA��O ou de ADEQUA��O A QUALQUER PROP�SITO EM       //
//              PARTICULAR. Consulte a Licen�a P�blica Geral GNU para obter   //
//              mais detalhes. Voc� deve ter recebido uma c�pia da Licen�a    //
//              P�blica Geral GNU junto com este programa; se n�o, escreva    //
//              para a Free Software Foundation, Inc., 59 Temple Place,       //
//              Suite 330, Boston, MA - 02111-1307, USA ou consulte a         //
//              licen�a oficial em http://www.gnu.org/licenses/gpl.txt        //
//                                                                            //
//    Nota (1): - Esta  licen�a  n�o  concede  o  direito  de  uso  do nome   //
//              "PCN  -  Projeto  Cooperar  NFe", n�o  podendo o mesmo ser    //
//              utilizado sem previa autoriza��o.                             //
//                                                                            //
//    Nota (2): - O uso integral (ou parcial) das units do projeto esta       //
//              condicionado a manuten��o deste cabe�alho junto ao c�digo     //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

{$I ACBr.inc}

unit pcnGerador;

interface

uses
  SysUtils, Classes,
{$IFNDEF VER130}
  Variants,
{$ENDIF}
  pcnAuxiliar, pcnConversao;

type

  TGeradorOpcoes = class;

  { TGerador }

  TGerador = class(TPersistent)
  private
    FArquivoFormatoXML: AnsiString;
    FArquivoFormatoTXT: AnsiString;
    FLayoutArquivoTXT: TstringList;
    FListaDeAlertas: TStringList;
    FTagNivel: string;
    FIDNivel: string;
    FOpcoes: TGeradorOpcoes;
    FPrefixo : string;
  public
    FIgnorarTagNivel: string;
    FIgnorarTagIdentacao: string;
    constructor Create;
    destructor Destroy; override;
    function SalvarArquivo(const CaminhoArquivo: string; const FormatoGravacao: TpcnFormatoGravacao = fgXML): Boolean;
    procedure wGrupo(const TAG: string; ID: string = ''; const Identar: Boolean = True);
    procedure wCampo(const Tipo: TpcnTipoCampo; ID, TAG: string; const min, max, ocorrencias: smallint; const valor: variant; const Descricao: string = ''; ParseTextoXML: Boolean = True; Atributo: String = '');
    procedure wGrupoNFSe(const TAG: string; ID: string = ''; const Identar: Boolean = True);
    procedure wCampoNFSe(const Tipo: TpcnTipoCampo; ID, TAG: string; const min, max, ocorrencias: smallint; const valor: variant; const Descricao: string = ''; ParseTextoXML: Boolean = True; Atributo: String = '');
    procedure wCampoCNPJCPF(const ID1, ID2: string; CNPJCPF: string; obrigatorio: Boolean = True; PreencheZeros: Boolean = True);
    procedure wCampoCNPJ(const ID: string; CNPJ: string; const cPais: Integer; obrigatorio: Boolean);
    procedure wCampoCPF(const ID: string; CPF: string; const cPais: Integer; obrigatorio: Boolean);
    procedure wAlerta(const ID, TAG, Descricao, Alerta: string);
    procedure wTexto(const Texto: string);
    procedure gtNivel(ID: string);
    procedure gtCampo(const Tag, ConteudoProcessado: string);
    procedure gtAjustarRegistros(const ID: string);
  published
    property ArquivoFormatoXML: AnsiString read FArquivoFormatoXML write FArquivoFormatoXML;
    property ArquivoFormatoTXT: AnsiString read FArquivoFormatoTXT write FArquivoFormatoTXT;
    property IDNivel: string read FIDNivel write FIDNivel;
    property ListaDeAlertas: TStringList read FListaDeAlertas write FListaDeAlertas;
    property LayoutArquivoTXT: TStringList read FLayoutArquivoTXT write FLayoutArquivoTXT;
    property Opcoes: TGeradorOpcoes read FOpcoes write FOpcoes;
    property Prefixo: string read FPrefixo write FPrefixo;
  end;

  { TGeradorOpcoes }

  TGeradorOpcoes = class(TPersistent)
  private
    FDecimalChar: Char;
    FSomenteValidar: boolean;
    FIdentarXML: boolean;
    FRetirarEspacos: boolean;
    FRetirarAcentos: boolean;
    FNivelIdentacao: integer;
    FTamanhoIdentacao: integer;
    FSuprimirDecimais: boolean;
    FTagVaziaNoFormatoResumido: boolean;
    FFormatoAlerta: string;
  public
    constructor Create;

  published
    property SomenteValidar: boolean read FSomenteValidar write FSomenteValidar default False;
    property RetirarEspacos: boolean read FRetirarEspacos write FRetirarEspacos default True;
    property RetirarAcentos: boolean read FRetirarAcentos write FRetirarAcentos default True;
    property IdentarXML: boolean read FIdentarXML write FIdentarXML default False;
    property TamanhoIdentacao: integer read FTamanhoIdentacao write FTamanhoIdentacao default 3;
    property SuprimirDecimais: boolean read FSuprimirDecimais write FSuprimirDecimais default False;
    property TagVaziaNoFormatoResumido: boolean read FTagVaziaNoFormatoResumido write FTagVaziaNoFormatoResumido default True;
    property FormatoAlerta: string read FFormatoAlerta write FFormatoAlerta;
    property DecimalChar: Char read FDecimalChar write FDecimalChar default '.';
  end;

const

  ERR_MSG_MAIOR = 'Tamanho maior que o m�ximo permitido';
  ERR_MSG_MENOR = 'Tamanho menor que o m�nimo permitido';
  ERR_MSG_VAZIO = 'Nenhum valor informado';
  ERR_MSG_INVALIDO = 'Conte�do inv�lido';
  ERR_MSG_MAXIMO_DECIMAIS = 'Numero m�ximo de casas decimais permitidas';
  ERR_MSG_MAIOR_MAXIMO = 'N�mero de ocorr�ncias maior que o m�ximo permitido - M�ximo ';
  ERR_MSG_GERAR_CHAVE = 'Erro ao gerar a chave da NFe!';
  ERR_MSG_FINAL_MENOR_INICIAL = 'O numero final n�o pode ser menor que o inicial';
  ERR_MSG_ARQUIVO_NAO_ENCONTRADO = 'Arquivo n�o encontrado';
  ERR_MSG_SOMENTE_UM = 'Somente um campo deve ser preenchido';
  ERR_MSG_MENOR_MINIMO = 'N�mero de ocorr�ncias menor que o m�nimo permitido - M�nimo ';

  CODIGO_BRASIL = 1058;

  XML_V01           = '?xml version="1.0"?';
  ENCODING_UTF8     = '?xml version="1.0" encoding="UTF-8"?';
  ENCODING_UTF8_STD = '?xml version="1.0" encoding="UTF-8" standalone="no"?';

  NAME_SPACE      = 'xmlns="http://www.portalfiscal.inf.br/nfe"';
  NAME_SPACE_CTE  = 'xmlns="http://www.portalfiscal.inf.br/cte"';
  NAME_SPACE_CFE  = 'xmlns="http://www.fazenda.sp.gov.br/sat"';
  NAME_SPACE_MDFE = 'xmlns="http://www.portalfiscal.inf.br/mdfe"';
  NAME_SPACE_GNRE = 'xmlns="http://www.gnre.pe.gov.br"';

  V0_02 = 'versao="0.02"';
  V1_00 = 'versao="1.00"';
  V1_01 = 'versao="1.01"';
  V1_02 = 'versao="1.02"';
  V1_03 = 'versao="1.03"';
  V1_04 = 'versao="1.04"';
  V1_07 = 'versao="1.07"';
  V1_10 = 'versao="1.10"';
  V2_00 = 'versao="2.00"';
  V2_01 = 'versao="2.01"';

  DSC_CNPJ = 'CNPJ(MF)';
  DSC_CPF = 'CPF';

  //CFe - Cupom Fiscal Eletr�nico - SAT
  DSC_VDESCSUBTOT = 'Valor de Desconto sobre Subtotal';
  DSC_VACRESSUBTOT = 'Valor de Acr�scimo sobre Subtotal';
  DSC_VPISST = 'Valor do PIS ST';
  DSC_VCOFINSST = 'Valor do COFINS ST';
  DSC_VCFE = 'Valor Total do CF-e';
  DSC_VCFELEI12741 = 'Valor aproximado dos tributos do CFe-SAT � Lei 12741/12.';
  DSC_VDEDUCISS = 'Valor das dedu��es para ISSQN';
  DSC_CSERVTRIBMUN = 'Codigo de tributa��o pelo ISSQN do municipio';
  DSC_CNATOP = 'Natureza da Opera��o de ISSQN';
  DSC_INDINCFISC = 'Indicador de Incentivo Fiscal do ISSQN';
  DSC_COFINSST = 'Grupo de COFINS Substitui��o Tribut�ria';
  DSC_REGTRIB = 'C�digo de Regime Tribut�rio';
  DSC_REGISSQN = 'Regime Especial de Tributa��o do ISSQN';
  DSC_RATISSQN = 'Indicador de rateio do Desconto sobre subtotal entre itens sujeitos � tributa��o pelo ISSQN.';
  DSC_NCFE = 'N�mero do Cupom Fiscal Eletronico';
  DSC_HEMI = 'Hora de emiss�o';
  DSC_SIGNAC = 'Assinatura do Aplicativo Comercial';
  DSC_QRCODE = 'Assinatura Digital para uso em QRCODE';
  DSC_MP = 'Grupo de informa��es sobre Pagamento do CFe';
  DSC_CMP = 'C�digo do Meio de Pagamento';
  DSC_VMP = 'Valor do Meio de Pagamento';
  DSC_CADMC = 'Credenciadora de cart�o de d�bito ou cr�dito';
  DSC_VTROCO = 'Valor do troco';
  DSC_VITEM = 'Valor l�quido do Item';
  DSC_VRATDESC = 'Rateio do desconto sobre subtotal';
  DSC_VRATACR = 'Rateio do acr�scimo sobre subtotal';
  DSC_NUMEROCAIXA = 'N�mero do Caixa ao qual o SAT est� conectado';
  DSC_VITEM12741 = 'Valor aproximado dos tributos do Produto ou servi�o � Lei 12741/12';

implementation

uses
  DateUtils, ACBrConsts, ACBrUtil;

{ TGeradorOpcoes }

constructor TGeradorOpcoes.Create;
begin
  inherited;

  FIdentarXML := False;
  FTamanhoIdentacao := 3;
  FFormatoAlerta := 'TAG:%TAGNIVEL% ID:%ID%/%TAG%(%DESCRICAO%) - %MSG%.'; // Vide coment�rio em wAlerta
  FRetirarEspacos := True;
  FRetirarAcentos := True;
  FSuprimirDecimais := False;
  FSomenteValidar := False;
  FTagVaziaNoFormatoResumido := True;
  FDecimalChar := '.';
end;

{ TGerador }

constructor TGerador.Create;
begin
  inherited;

  FOpcoes := TGeradorOpcoes.Create;
  FListaDeAlertas := TStringList.Create;
  FLayoutArquivoTXT := TStringList.Create;
end;

destructor TGerador.Destroy;
begin
  FOpcoes.Free;
  FListaDeAlertas.Free;
  FLayoutArquivoTXT.Free;
  FIgnorarTagNivel := '!@#';
  FIgnorarTagIdentacao := '!@#';
  inherited Destroy;
end;

function TGerador.SalvarArquivo(const CaminhoArquivo: string; const FormatoGravacao: TpcnFormatoGravacao = fgXML): Boolean;
var
  ArquivoGerado: TStringList;
begin
  // Formato de grava��o somente � v�lido para NFe
  ArquivoGerado := TStringList.Create;
  try
    try
      if FormatoGravacao = fgXML then
        ArquivoGerado.Add(FArquivoFormatoXML)
      else
        ArquivoGerado.Add(FArquivoFormatoTXT);
      ArquivoGerado.SaveToFile(CaminhoArquivo);
      Result := True;
    except
      Result := False;
      raise;
    end;
  finally
    ArquivoGerado.Free;
  end;
end;

procedure TGerador.wAlerta(const ID, TAG, Descricao, Alerta: string);
var
  s: string;
begin
  // O Formato da mensagem de erro pode ser alterado pelo usuario alterando-se a property FFormatoAlerta: onde;
  // %TAGNIVEL%  : Representa o Nivel da TAG; ex: <transp><vol><lacres>
  // %TAG%       : Representa a TAG; ex: <nLacre>
  // %ID%        : Representa a ID da TAG; ex X34
  // %MSG%       : Representa a mensagem de alerta
  // %DESCRICAO% : Representa a Descri��o da TAG
  s := FOpcoes.FFormatoAlerta;
  s := stringReplace(s, '%TAGNIVEL%', FTagNivel, [rfReplaceAll]);
  s := stringReplace(s, '%TAG%', TAG, [rfReplaceAll]);
  s := stringReplace(s, '%ID%', ID, [rfReplaceAll]);
  s := stringReplace(s, '%MSG%', Alerta, [rfReplaceAll]);
  s := stringReplace(s, '%DESCRICAO%', Trim(Descricao), [rfReplaceAll]);
  if Trim(Alerta) <> '' then
    FListaDeAlertas.Add(s);
end;

procedure TGerador.wGrupo(const TAG: string; ID: string = ''; const Identar: Boolean = True);
begin
  // A propriedade FIgnorarTagNivel � utilizada para Ignorar TAG
  // na constru��o dos n�veis para apresenta��o na mensagem de erro.
  gtNivel(ID);
  // Caso a tag seja um Grupo com Atributo
  if (pos('="', TAG) > 0) or (pos('= "', TAG) > 0) then
    gtCampo(RetornarConteudoEntre(TAG, ' ', '='), RetornarConteudoEntre(TAG, '"', '"'));
  //
  if not SubStrEmSubStr(TAG, FIgnorarTagNivel) then
  begin
    if TAG[1] <> '/' then
      FTagNivel := FTagNivel + '<' + TAG + '>';
    if (TAG[1] = '/') and (Copy(TAG, 2, 3) = 'det') then
      FTagNivel := copy(FTagNivel, 1, pos('<det', FTagNivel) - 1)
    else
      FTagNivel := StringReplace(FTagNivel, '<' + Copy(TAG, 2, MaxInt) + '>', '', []);
  end;
  //
  if (Identar) and (TAG[1] = '/') then
    Dec(FOpcoes.FNivelIdentacao);
  if SubStrEmSubStr(TAG, FIgnorarTagIdentacao) then
    Dec(FOpcoes.FNivelIdentacao);
  //
  if FOpcoes.IdentarXML then
    FArquivoFormatoXML := FArquivoFormatoXML + StringOfChar(' ', FOpcoes.FTamanhoIdentacao * FOpcoes.FNivelIdentacao) + '<' + tag + '>' + #13#10
  else
    FArquivoFormatoXML := FArquivoFormatoXML + '<' + tag + '>';
  if (Identar) and (TAG[1] <> '/') then
    Inc(FOpcoes.FNivelIdentacao);
end;

procedure TGerador.wCampoCNPJCPF(const ID1, ID2: string; CNPJCPF: string;
  obrigatorio: Boolean; PreencheZeros: Boolean);
var
  Tamanho: integer;
  Ocorrencia: Integer;
begin
  CNPJCPF    := SomenteNumeros(trim(CNPJCPF));
  Tamanho    := length(CNPJCPF);
  Ocorrencia := Integer(obrigatorio);

  if (Tamanho <= 11) and (Tamanho > 0) then    // Se Vazio d� preferencia a CNPJ
  begin
    if PreencheZeros and (Tamanho <> 11) then
    begin
      CNPJCPF := PadLeft(CNPJCPF,11,'0');
      Tamanho := 11;
    end;

    wCampo(tcStr, ID2, 'CPF  ', 0, 11, Ocorrencia, CNPJCPF);
    if not ValidarCPF(CNPJCPF) then
      wAlerta(ID2, 'CPF', 'CPF', ERR_MSG_INVALIDO);
  end
  else
  begin
    if PreencheZeros and (obrigatorio or (Tamanho > 0))  and (Tamanho <> 14) then
    begin
      CNPJCPF := PadLeft(CNPJCPF,14,'0');
      Tamanho := 14;
    end;

    wCampo(tcStr, ID1, 'CNPJ', 0, 14, Ocorrencia, CNPJCPF);
    if (Tamanho > 0) and (not ValidarCNPJ(CNPJCPF)) then
      wAlerta(ID1, 'CNPJ', 'CNPJ', ERR_MSG_INVALIDO);
  end;

  if (not (Tamanho in[0,11,14])) then
    wAlerta(ID1 + '-' + ID2, 'CNPJ-CPF', 'CNPJ/CPF', ERR_MSG_INVALIDO);
end;

procedure TGerador.wCampoCNPJ(const ID: string; CNPJ: string; const cPais: Integer; obrigatorio: Boolean);
begin
  if cPais <> 1058 then
  begin
    wCampo(tcStr, ID, 'CNPJ', 00, 00, 1, '');
    exit;
  end;
  CNPJ := SomenteNumeros(trim(CNPJ));
  if obrigatorio then
    wCampo(tcEsp, ID, 'CNPJ', 14, 14, 1, CNPJ, DSC_CNPJ)
  else
    wCampo(tcEsp, ID, 'CNPJ', 14, 14, 0, CNPJ, DSC_CNPJ);
  if not ValidarCNPJ(CNPJ) then
    wAlerta(ID, 'CNPJ', DSC_CNPJ, ERR_MSG_INVALIDO);
end;

procedure TGerador.wCampoCPF(const ID: string; CPF: string; const cPais: Integer; obrigatorio: Boolean);
begin
  if cPais <> 1058 then
  begin
    wCampo(tcStr, ID, 'CPF', 00, 00, 1, '');
    exit;
  end;
  CPF := SomenteNumeros(trim(CPF));
  if obrigatorio then
    wCampo(tcEsp, ID, 'CPF', 11, 11, 1, CPF, DSC_CPF)
  else
    wCampo(tcEsp, ID, 'CPF', 11, 11, 0, CPF, DSC_CPF);
  if not ValidarCPF(CPF) then
    wAlerta(ID, 'CPF', DSC_CPF, ERR_MSG_INVALIDO);
end;

procedure TGerador.wCampo(const Tipo: TpcnTipoCampo; ID, TAG: string; const min, max, ocorrencias: smallint; const valor: variant; const Descricao: string = ''; ParseTextoXML : Boolean = True; Atributo: String = '');

  function IsEmptyDate( wAno, wMes, wDia: Word): Boolean;
  begin
    Result := ((wAno = 1899) and (wMes = 12) and (wDia = 30));
  end;

var
  NumeroDecimais: smallint;
  valorInt, TamMin, TamMax: Integer;
  valorDbl: Double;
  alerta, ConteudoProcessado, ATag: string;
  wAno, wMes, wDia, wHor, wMin, wSeg, wMse: Word;
  EstaVazio: boolean;
begin
  ID                  := Trim(ID);
  Tag                 := Trim(TAG);
  Atributo            := Trim(Atributo);
  EstaVazio           := False;
  NumeroDecimais      := 0;
  ConteudoProcessado  := '';
  TamMax              := max;
  TamMin              := min;

  case Tipo of
    tcStr:
      begin
        ConteudoProcessado := Trim( VarToStr(valor) );
        EstaVazio := ConteudoProcessado = '';
      end;

    tcDat, tcDatCFe:
      begin
        DecodeDate( VarToDateTime(valor), wAno, wMes, wDia);
        ConteudoProcessado := FormatFloat('0000', wAno) + '-' + FormatFloat('00', wMes) + '-' + FormatFloat('00', wDia);
        if Tipo = tcDatCFe then
          ConteudoProcessado := SomenteNumeros(ConteudoProcessado);

        EstaVazio := IsEmptyDate( wAno, wMes, wDia );
      end;

    tcDatVcto:
      begin
        DecodeDate( VarToDateTime(valor), wAno, wMes, wDia);
        ConteudoProcessado := FormatFloat('00', wDia)+ '/' + FormatFloat('00', wMes)+ '/' +FormatFloat('0000', wAno);
        EstaVazio := IsEmptyDate( wAno, wMes, wDia );
      end;

    tcHor, tcHorCFe:
      begin
        DecodeTime( VarToDateTime(valor), wHor, wMin, wSeg, wMse);
        ConteudoProcessado := FormatFloat('00', wHor) + ':' + FormatFloat('00', wMin) + ':' + FormatFloat('00', wSeg);
        if Tipo = tcHorCFe then
          ConteudoProcessado := SomenteNumeros(ConteudoProcessado);

        EstaVazio := (wHor = 0) and (wMin = 0) and (wSeg = 0);
      end;

    tcDatHor:
      begin
        DecodeDateTime( VarToDateTime(valor), wAno, wMes, wDia, wHor, wMin, wSeg, wMse);
        ConteudoProcessado := FormatFloat('0000', wAno) + '-' +
                              FormatFloat('00', wMes) + '-' +
                              FormatFloat('00', wDia) + 'T' +
                              FormatFloat('00', wHor) + ':' +
                              FormatFloat('00', wMin) + ':' +
                              FormatFloat('00', wSeg);
        EstaVazio := ((wAno = 1899) and (wMes = 12) and (wDia = 30));
      end;

    tcDe2, tcDe3, tcDe4, tcDe6, tcDe10:
      begin
        // adicionar um para que o m�ximo e m�nimo n�o considerem a virgula
        if not FOpcoes.FSuprimirDecimais then
        begin
          TamMax := TamMax + 1;
          TamMin := TamMin + 1;
        end;
        
        // Tipo numerico com decimais
        case Tipo of
          tcDe2 : NumeroDecimais :=  2;
          tcDe3 : NumeroDecimais :=  3;
          tcDe4 : NumeroDecimais :=  4;
          tcDe6 : NumeroDecimais :=  6;
          tcDe10: NumeroDecimais := 10;
        end;

        try
          valorDbl := valor; // Converte Variant para Double
          ConteudoProcessado := FloatToString( valorDbl, FOpcoes.DecimalChar, FloatMask(NumeroDecimais));
        except
          valorDbl := 0;
          ConteudoProcessado := '0.00';
        end;

        EstaVazio := (valorDbl = 0) and (ocorrencias = 0);

        if StrToIntDef(Copy(ConteudoProcessado, pos(FOpcoes.DecimalChar, ConteudoProcessado) + NumeroDecimais + 1, 10),0) > 0 then
          walerta(ID, Tag, Descricao, ERR_MSG_MAXIMO_DECIMAIS + ' ' + IntToStr(NumeroDecimais));

        // Caso n�o seja um valor fracion�rio; retira os decimais.
        if FOpcoes.FSuprimirDecimais then
          if int(valorDbl) = valorDbl then
            ConteudoProcessado := IntToStr(Round(valorDbl));

        if Length(ConteudoProcessado) < TamMin then
          ConteudoProcessado := PadLeft(ConteudoProcessado, TamMin, '0');
      end;

    tcEsp:
      begin
        // Tipo String - somente numeros
        ConteudoProcessado  := trim(valor);
        EstaVazio           := (valor = '');
        if not ValidarNumeros(ConteudoProcessado) then
          walerta(ID, Tag, Descricao, ERR_MSG_INVALIDO);
      end;

    tcInt:
      begin
        // Tipo Inteiro
        try
          valorInt := valor;
          ConteudoProcessado := IntToStr(valorInt);
        except
          valorInt := 0;
          ConteudoProcessado := '0';
        end;

        EstaVazio := (valorInt = 0) and (ocorrencias = 0);

        if Length(ConteudoProcessado) < TamMin then
          ConteudoProcessado := PadLeft(ConteudoProcessado, TamMin, '0');
      end;
  end;

  alerta := '';
  //(Existem tags obrigat�rias que podem ser nulas ex. cEAN)  if (ocorrencias = 1) and (EstaVazio) then
  if (ocorrencias = 1) and (EstaVazio) and (TamMin > 0) then
    alerta := ERR_MSG_VAZIO;

  if (length(ConteudoProcessado) < TamMin) and (alerta = '') and (length(ConteudoProcessado) > 1) then
    alerta := ERR_MSG_MENOR;

  if length(ConteudoProcessado) > TamMax then
     alerta := ERR_MSG_MAIOR;

  // Grava alerta //
  if (alerta <> '') and (pos(ERR_MSG_VAZIO, alerta) = 0) and (not EstaVazio) then
    alerta := alerta + ' [' + VarToStr(valor) + ']';

  walerta(ID, TAG, Descricao, alerta);
  // Sai se for apenas para validar //
  if FOpcoes.FSomenteValidar then
    exit;

  // Grava no Formato Texto
  if not EstaVazio then
    gtCampo(tag, ConteudoProcessado)
  else
    gtCampo(tag, '');

  // adiciona o espa�o ao inicio do atributo para n�o colar na tag se nao estiver vazio
  if Atributo <> '' then
    Atributo := ' ' + Atributo;

  // Grava a tag no arquivo - Quando n�o existir algum conte�do
  if ((ocorrencias = 1) and (EstaVazio)) then
  begin
    if FOpcoes.FIdentarXML then
    begin
      if FOpcoes.FTagVaziaNoFormatoResumido then
        FArquivoFormatoXML := FArquivoFormatoXML + StringOfChar(' ', FOpcoes.FTamanhoIdentacao * FOpcoes.FNivelIdentacao) + '<' + tag + '/>' + #13#10
      else
        FArquivoFormatoXML := FArquivoFormatoXML + StringOfChar(' ', FOpcoes.FTamanhoIdentacao * FOpcoes.FNivelIdentacao) + '<' + tag + '></' + tag + '>' + #13#10
    end
    else
    begin
      if FOpcoes.FTagVaziaNoFormatoResumido then
        FArquivoFormatoXML := FArquivoFormatoXML + '<' + tag + Atributo + '/>'
      else
        FArquivoFormatoXML := FArquivoFormatoXML + '<' + tag + Atributo +  '></' + tag + '>';
    end;
    exit;
  end;

  // Grava a tag no arquivo - Quando existir algum conte�do
  if ((ocorrencias = 1) or (not EstaVazio)) then
  begin
    if ParseTextoXML then
       ATag := '<' + tag + Atributo +  '>' +
               FiltrarTextoXML(FOpcoes.FRetirarEspacos, ConteudoProcessado, FOpcoes.FRetirarAcentos) +
               '</' + tag + '>'
    else
       ATag := '<' + tag + Atributo +  '>' +
               ConteudoProcessado +
               '</' + tag + '>';

    if FOpcoes.FIdentarXML then
      FArquivoFormatoXML := FArquivoFormatoXML +
         StringOfChar(' ', FOpcoes.FTamanhoIdentacao * FOpcoes.FNivelIdentacao) +
         ATag + sLineBreak
    else
      FArquivoFormatoXML := FArquivoFormatoXML + ATag;
  end;
end;

procedure TGerador.wTexto(const Texto: string);
begin
  FArquivoFormatoXML := FArquivoFormatoXML + Texto;
end;

// Gerador TXT

procedure TGerador.gtNivel(ID: string);
var
  i: integer;
begin
  ID := UpperCase(ID);
  FIDNivel := ID;
  if (FLayoutArquivoTXT.Count = 0) or (ID = '') then
    exit;
  for i := 0 to FLayoutArquivoTXT.Count - 1 do
    if pos('<' + ID + '>', UpperCase(FLayoutArquivoTXT.Strings[i])) > 0 then
      FArquivoFormatoTXT := FArquivoFormatoTXT + FLayoutArquivoTXT.Strings[i] + #13;
end;

procedure TGerador.gtCampo(const Tag, ConteudoProcessado: string);
var
  i: integer;
  List: TstringList;
begin
  if FLayoutArquivoTXT.Count = 0 then
    exit;
  List := TStringList.Create;
  List.Text := FArquivoFormatoTXT;
  //
  for i := 0 to List.count - 1 do
    if pos('<' + FIDNivel + '>', List.Strings[i]) > 0 then
      if pos('|' + UpperCase(Tag) + '�', UpperCase(List.Strings[i])) > 0 then
        List[i] := StringReplace(List[i], '|' + UpperCase(Trim(TAG)) + '�', '|' + conteudoProcessado, []);
  //
  FArquivoFormatoTXT := List.Text;
  List.Free;
end;

procedure TGerador.gtAjustarRegistros(const ID: string);
var
  i, j, k: integer;
  s, idLocal: string;
  ListArquivo: TstringList;
  ListCorrigido: TstringList;
  ListTAGs: TstringList;
begin
  if FLayoutArquivoTXT.Count = 0 then
    exit;
  ListTAGs := TStringList.Create;
  ListArquivo := TStringList.Create;
  ListCorrigido := TStringList.Create;
  // Elimina registros n�o utilizados
  ListArquivo.Text := FArquivoFormatoTXT;
  for i := 0 to ListArquivo.count - 1 do
  begin
    k := 0;
    for j := 0 to FLayoutArquivoTXT.count - 1 do
      if listArquivo[i] = FLayoutArquivoTXT[j] then
        if pos('�', listArquivo[i]) > 0 then
          k := 1;
    if k = 0 then
      ListCorrigido.add(ListArquivo[i]);
  end;
  // Insere dados da chave da Nfe
  for i := 0 to ListCorrigido.count - 1 do
    if pos('^ID^', ListCorrigido[i]) > 1 then
      ListCorrigido[i] := StringReplace(ListCorrigido[i], '^ID^', ID, []);
  // Elimina Nome de TAG sem informa��o
  for j := 0 to FLayoutArquivoTXT.count - 1 do
  begin
    s := FLayoutArquivoTXT[j];
    while (pos('|', s) > 0) and (pos('�', s) > 0) do
    begin
      s := copy(s, pos('|', s), maxInt);
      ListTAGs.add(copy(s, 1, pos('�', s)));
      s := copy(s, pos('�', s) + 1, maxInt);
    end;
  end;
  for i := 0 to ListCorrigido.count - 1 do
    for j := 0 to ListTAGs.count - 1 do
      ListCorrigido[i] := StringReplace(ListCorrigido[i], ListTAGs[j], '|', []);
  // Elimina Bloco <ID>
  for i := 0 to ListCorrigido.count - 1 do
    if pos('>', ListCorrigido[i]) > 0 then
     begin
      ListCorrigido[i] := Trim(copy(ListCorrigido[i], pos('>', ListCorrigido[i]) + 1, maxInt));
      idLocal := copy(ListCorrigido[i],1,pos('|',ListCorrigido[i])-1);

      if (length(idLocal) > 2) and (UpperCase(idLocal) <> 'NOTA FISCAL') and
         (copy(idLocal,length(idLocal),1) <> SomenteNumeros(copy(idLocal,length(idLocal),1))) then
       begin
         idLocal := copy(idLocal,1,length(idLocal)-1)+LowerCase(copy(idLocal,length(idLocal),1));
         ListCorrigido[i] := StringReplace(ListCorrigido[i],idLocal,idLocal,[rfIgnoreCase]);
       end;
     end;
  FArquivoFormatoTXT := ListCorrigido.Text;
  //
  ListTAGs.Free;
  ListArquivo.Free;
  ListCorrigido.Free;
end;

procedure TGerador.wCampoNFSe(const Tipo: TpcnTipoCampo; ID, TAG: string;
  const min, max, ocorrencias: smallint; const valor: variant;
  const Descricao: string; ParseTextoXML: Boolean; Atributo: String);
begin
  Self.wCampo(Tipo, ID, Self.Prefixo + TAG, min, max, ocorrencias, valor,
              Descricao, ParseTextoXML, Atributo);
end;

procedure TGerador.wGrupoNFSe(const TAG: string; ID: string;
  const Identar: Boolean);
begin
  if copy(TAG, 1, 1) = '/' then
     Self.wGrupo('/' + Self.Prefixo + copy(TAG, 2, length(TAG)), ID, Identar)
  else
     Self.wGrupo(Self.Prefixo + TAG, ID, Identar);
end;

end.

