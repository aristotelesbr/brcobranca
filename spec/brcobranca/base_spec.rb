# -*- encoding: utf-8 -*-
require 'spec_helper'

module Brcobranca #:nodoc:[all]
  module Boleto #:nodoc:[all]
    describe Base do
      before(:each) do
        @valid_attributes = {
          :especie_documento => "DM",
          :moeda => "9",
          :data_documento => Date.today,
          :dias_vencimento => 1,
          :aceite => "S",
          :quantidade => 1,
          :valor => 0.0,
          :local_pagamento => "QUALQUER BANCO ATÉ O VENCIMENTO",
          :cedente => "Kivanio Barbosa",
          :documento_cedente => "12345678912",
          :sacado => "Claudio Pozzebom",
          :sacado_documento => "12345678900",
          :agencia => "4042",
          :conta_corrente => "61900",
          :convenio => 12387989,
          :numero_documento => "777700168"
        }
      end

      it "Criar nova instancia com atributos padrões" do
        boleto_novo = Brcobranca::Boleto::Base.new
        expect(boleto_novo.especie_documento).to eql("DM")
        expect(boleto_novo.especie).to eql("R$")
        expect(boleto_novo.moeda).to eql("9")
        expect(boleto_novo.data_documento).to eql(Date.today)
        expect(boleto_novo.dias_vencimento).to eql(1)
        expect(boleto_novo.data_vencimento).to eql(Date.today + 1)
        expect(boleto_novo.aceite).to eql("S")
        expect(boleto_novo.quantidade).to eql(1)
        expect(boleto_novo.valor).to eql(0.0)
        expect(boleto_novo.valor_documento).to eql(0.0)
        expect(boleto_novo.local_pagamento).to eql("QUALQUER BANCO ATÉ O VENCIMENTO")
        expect(boleto_novo.valid?).to be_falsey
      end

      it "Criar nova instancia com atributos válidos" do
        boleto_novo = Brcobranca::Boleto::Base.new(@valid_attributes)
        expect(boleto_novo.especie_documento).to eql("DM")
        expect(boleto_novo.especie).to eql("R$")
        expect(boleto_novo.moeda).to eql("9")
        expect(boleto_novo.data_documento).to eql(Date.today)
        expect(boleto_novo.dias_vencimento).to eql(1)
        expect(boleto_novo.data_vencimento).to eql(Date.today + 1)
        expect(boleto_novo.aceite).to eql("S")
        expect(boleto_novo.quantidade).to eql(1)
        expect(boleto_novo.valor).to eql(0.0)
        expect(boleto_novo.valor_documento).to eql(0.00)
        expect(boleto_novo.local_pagamento).to eql("QUALQUER BANCO ATÉ O VENCIMENTO")
        expect(boleto_novo.cedente).to eql("Kivanio Barbosa")
        expect(boleto_novo.documento_cedente).to eql("12345678912")
        expect(boleto_novo.sacado).to eql("Claudio Pozzebom")
        expect(boleto_novo.sacado_documento).to eql("12345678900")
        expect(boleto_novo.conta_corrente).to eql("0061900")
        expect(boleto_novo.agencia).to eql("4042")
        expect(boleto_novo.convenio).to eql(12387989)
        expect(boleto_novo.numero_documento).to eql("777700168")
        expect(boleto_novo.valid?).to be_truthy
      end

      it "Calcula agencia_dv" do
        boleto_novo = Brcobranca::Boleto::Base.new(@valid_attributes)
        boleto_novo.agencia = "85068014982"
        expect(boleto_novo.agencia_dv).to eql(9)
        boleto_novo.agencia = "05009401448"
        expect(boleto_novo.agencia_dv).to eql(1)
        boleto_novo.agencia = "12387987777700168"
        expect(boleto_novo.agencia_dv).to eql(2)
        boleto_novo.agencia = "4042"
        expect(boleto_novo.agencia_dv).to eql(8)
        boleto_novo.agencia = "61900"
        expect(boleto_novo.agencia_dv).to eql(0)
        boleto_novo.agencia = "0719"
        expect(boleto_novo.agencia_dv).to eql(6)
        boleto_novo.agencia = 85068014982
        expect(boleto_novo.agencia_dv).to eql(9)
        boleto_novo.agencia = 5009401448
        expect(boleto_novo.agencia_dv).to eql(1)
        boleto_novo.agencia = 12387987777700168
        expect(boleto_novo.agencia_dv).to eql(2)
        boleto_novo.agencia = 4042
        expect(boleto_novo.agencia_dv).to eql(8)
        boleto_novo.agencia = 61900
        expect(boleto_novo.agencia_dv).to eql(0)
        boleto_novo.agencia = 719
        expect(boleto_novo.agencia_dv).to eql(6)
      end

      it "Calcula conta_corrente_dv" do
        boleto_novo = Brcobranca::Boleto::Base.new(@valid_attributes)
        boleto_novo.conta_corrente = "85068014982"
        expect(boleto_novo.conta_corrente_dv).to eql(9)
        boleto_novo.conta_corrente = "05009401448"
        expect(boleto_novo.conta_corrente_dv).to eql(1)
        boleto_novo.conta_corrente = "12387987777700168"
        expect(boleto_novo.conta_corrente_dv).to eql(2)
        boleto_novo.conta_corrente = "4042"
        expect(boleto_novo.conta_corrente_dv).to eql(8)
        boleto_novo.conta_corrente = "61900"
        expect(boleto_novo.conta_corrente_dv).to eql(0)
        boleto_novo.conta_corrente = "0719"
        expect(boleto_novo.conta_corrente_dv).to eql(6)
        boleto_novo.conta_corrente = 85068014982
        expect(boleto_novo.conta_corrente_dv).to eql(9)
        boleto_novo.conta_corrente = 5009401448
        expect(boleto_novo.conta_corrente_dv).to eql(1)
        boleto_novo.conta_corrente = 12387987777700168
        expect(boleto_novo.conta_corrente_dv).to eql(2)
        boleto_novo.conta_corrente = 4042
        expect(boleto_novo.conta_corrente_dv).to eql(8)
        boleto_novo.conta_corrente = 61900
        expect(boleto_novo.conta_corrente_dv).to eql(0)
        boleto_novo.conta_corrente = 719
        expect(boleto_novo.conta_corrente_dv).to eql(6)
      end

      it "Calcula o valor do documento" do
        boleto_novo = Brcobranca::Boleto::Base.new(@valid_attributes)
        boleto_novo.quantidade = 1
        boleto_novo.valor = 1
        expect(boleto_novo.valor_documento).to eql(1.0)
        boleto_novo.quantidade = 1
        boleto_novo.valor = 1.0
        expect(boleto_novo.valor_documento).to eql(1.0)
        boleto_novo.quantidade = 100
        boleto_novo.valor = 1
        expect(boleto_novo.valor_documento).to eql(100.0)
        boleto_novo.quantidade = 1
        boleto_novo.valor = 1.2
        expect(boleto_novo.valor_documento).to eql(1.2)
        boleto_novo.quantidade = 1
        boleto_novo.valor = 135.43
        expect(boleto_novo.valor_documento).to eql(135.43)
        boleto_novo.quantidade = "gh"
        boleto_novo.valor = 135.43
        expect(boleto_novo.valor_documento).to eql(0.0)
      end

      it "Calcula data_vencimento" do
        boleto_novo = Brcobranca::Boleto::Base.new(@valid_attributes)
        boleto_novo.data_documento = Date.parse "2008-02-01"
        boleto_novo.dias_vencimento = 1
        expect(boleto_novo.data_vencimento.to_s).to eql("2008-02-02")
        expect(boleto_novo.data_vencimento).to eql(Date.parse("2008-02-02"))
        boleto_novo.data_documento = Date.parse "2008-02-02"
        boleto_novo.dias_vencimento = 28
        expect(boleto_novo.data_vencimento.to_s).to eql("2008-03-01")
        expect(boleto_novo.data_vencimento).to eql(Date.parse("2008-03-01"))
        boleto_novo.data_documento = Date.parse "2008-02-06"
        boleto_novo.dias_vencimento = 100
        expect(boleto_novo.data_vencimento.to_s).to eql("2008-05-16")
        expect(boleto_novo.data_vencimento).to eql(Date.parse("2008-05-16"))
        boleto_novo.data_documento = Date.parse "2008-02-06"
        boleto_novo.dias_vencimento = "df"
        expect(boleto_novo.data_vencimento).to eql(boleto_novo.data_documento)
      end

      it "Mostrar aviso sobre sobrecarga de métodos padrões" do
        boleto_novo = Brcobranca::Boleto::Base.new(@valid_attributes)
        expect { boleto_novo.codigo_barras_segunda_parte }.to raise_error(Brcobranca::NaoImplementado, "Sobreescreva este método na classe referente ao banco que você esta criando")
        expect { boleto_novo.nosso_numero_boleto }.to raise_error(Brcobranca::NaoImplementado, "Sobreescreva este método na classe referente ao banco que você esta criando")
        expect { boleto_novo.agencia_conta_boleto }.to raise_error(Brcobranca::NaoImplementado, "Sobreescreva este método na classe referente ao banco que você esta criando")
      end

      it "Incluir módulos de template na classe" do
        expect(Brcobranca::Boleto::Base.respond_to?(:lote)).to be_truthy
        expect(Brcobranca::Boleto::Base.respond_to?(:to)).to be_truthy
      end

      it "Incluir módulos de template na instancia" do
        boleto_novo = Brcobranca::Boleto::Base.new
        expect(boleto_novo.respond_to?(:lote)).to be_truthy
        expect(boleto_novo.respond_to?(:to)).to be_truthy
      end

    end
  end
end
