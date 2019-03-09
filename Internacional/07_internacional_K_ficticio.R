require("BIS")

## Aqui vamos fazer a replicação dos dados de Nakatani e Gomes e de Durand de estimativa de volume de capital ficticio


## Boa parte dos indicadores deveriam constar em proporção do PIB (, com possibilidade de mostrar em US$?)



### Ativos Bancários Totais 
## Valores totais

## %PIB

## FUTURO - %Ativos totais? ou % Ativos financeiros totais + total de capitalização de mercado


### Crédito total ao setor privado não financeiro
# Fonte da metodologia / inspiração Figure 8: Credit to the non-financial private sector (1970-2015) - Durand (2017)
# Fonte primária - Credit to the non-financial sector,  Bank for International Settlements
dadosbis <- get_datasets()
biscrednf <- get_bis(dadosbis$url[datasets$name == "Credit to the non-financial sector"],quiet = TRUE)


## Dívida Pública no Mundo (% PIB )

## Capitalização de Mercado (% PIB)



