# -*- encoding: utf-8 -*-
module Brcobranca
  module Boleto
    class Hsbc < Base # Banco HSBC

      validates_inclusion_of :carteira, :in => %w( CNR CSB ), :message => "não existente para este banco."
      validates_length_of :agencia, :maximum => 4, :message => "deve ser menor ou igual a 4 dígitos."
      validates_length_of :numero_documento, :maximum => 13, :message => "deve ser menor ou igual a 13 dígitos."
      validates_length_of :conta_corrente, :maximum => 7, :message => "deve ser menor ou igual a 7 dígitos."

      # Nova instancia do Hsbc
      # @param (see Brcobranca::Boleto::Base#initialize)
      def initialize(campos={})
        campos = {:carteira => "CNR"}.merge!(campos)
        super(campos)
      end

      # Codigo do banco emissor (3 dígitos sempre)
      #
      # @return [String] 3 caracteres numéricos.
      def banco
        "399"
      end

      # Número seqüencial utilizado para identificar o boleto.
      # @return [String] 13 caracteres numéricos.
      def numero_documento=(valor)
        @numero_documento = valor.to_s.rjust(13,'0') if valor
      end

      # Número seqüencial utilizado para identificar o boleto.
      #
      # O desenvolvedor poderá informar o código do nosso número quando gerado pelo banco
      # @param valor Nosso número
      def nosso_numero=(valor)
        @nosso_numero = valor
      end

      # Número seqüencial utilizado para identificar o boleto.
      #
      # Montagem é baseada na presença da data de vencimento.<br/>
      # <b>OBS:</b> Somente as carteiras <b>CNR/CSB</b> estão implementadas.<br/>
      #
      # @return [String]
      # @raise  [Brcobranca::NaoImplementado] Caso a carteira informada não for CNR/CSB.
      def nosso_numero
        case self.carteira
          when 'CNR' then
            if self.data_vencimento.kind_of?(Date)
              self.codigo_servico = "4"
              dia = self.data_vencimento.day.to_s.rjust(2,'0')
              mes = self.data_vencimento.month.to_s.rjust(2,'0')
              ano = self.data_vencimento.year.to_s[2..3]
              data = "#{dia}#{mes}#{ano}"

              parte_1 = "#{self.numero_documento}#{self.numero_documento.modulo11_9to2_10_como_zero}#{self.codigo_servico}"
              soma = parte_1.to_i + self.conta_corrente.to_i + data.to_i
              "#{parte_1}#{soma.to_s.modulo11_9to2_10_como_zero}"
            else
              raise "data_vencimento não é uma data."
            end
          when 'CSB'
            @nosso_numero
          else
            raise Brcobranca::NaoImplementado.new("Tipo de carteira não implementado.")
          # TODO - Verificar outras carteiras.
          # self.codigo_servico = "5"
          # parte_1 = "#{self.numero_documento}#{self.numero_documento.modulo11_9to2_10_como_zero}#{self.codigo_servico}"
          # soma = parte_1.to_i + self.conta_corrente.to_i
          # numero = "#{parte_1}#{soma.to_s.modulo11_9to2_10_como_zero}"
          # numero
        end
      end

      # Nosso número para exibir no boleto.
      # @return [String]
      # @example
      #  boleto.nosso_numero_boleto #=> "0000000004042847"
      def nosso_numero_boleto
        self.nosso_numero
      end

      # Número do convênio/contrato do cliente para exibir no boleto.
      # @return [String]
      # @example
      #  boleto.agencia_conta_boleto #=> "0061900"
      def agencia_conta_boleto
        self.conta_corrente
      end

      # Segunda parte do código de barras.
      #
      # Montagem é baseada no tipo de carteira e na presença da data de vencimento<br/>
      # <b>OBS:</b> Somente as carteiras <b>CNR/CSB</b> estão implementadas.<br/>
      #
      # @return [String] 25 caracteres numéricos.
      # @raise  [Brcobranca::NaoImplementado] Caso a carteira informada não for CNR/CSB.
      def codigo_barras_segunda_parte
        case self.carteira
          when "CNR"
            dias_julianos = self.data_vencimento.to_juliano
            "#{self.conta_corrente}#{self.numero_documento}#{dias_julianos}2"
          when "CSB"
            raise Brcobranca::NaoImplementado.new("Nosso número não definido.") unless @nosso_numero
            "#{self.nosso_numero}#{self.agencia}#{self.conta_corrente}001"
          else
            raise Brcobranca::NaoImplementado.new("Tipo de carteira não implementado.")
        end
      end

    end
  end
end