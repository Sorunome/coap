/*
 * Package : Coap
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 14/05/2018
 * Copyright :  S.Hamblett
 */

part of coap;

/// Base class for message encoders.
abstract class CoapMessageEncoder implements CoapIMessageEncoder {
  @override
  typed.Uint8Buffer encodeRequest(CoapRequest request) {
    final CoapDatagramWriter writer = CoapDatagramWriter();
    serialize(writer, request, request.code);
    return writer.toByteArray();
  }

  @override
  typed.Uint8Buffer encodeResponse(CoapResponse response) {
    final CoapDatagramWriter writer = CoapDatagramWriter();
    serialize(writer, response, response.code);
    return writer.toByteArray();
  }

  @override
  typed.Uint8Buffer encodeEmpty(CoapEmptyMessage message) {
    final CoapDatagramWriter writer = CoapDatagramWriter();
    serialize(writer, message, CoapCode.empty);
    return writer.toByteArray();
  }

  @override
  typed.Uint8Buffer encodeMessage(CoapMessage message) {
    if (message.isRequest || message.isEmpty) {
      // A request could be an empty message, i.e ping
      return encodeRequest(message);
    } else if (message.isResponse) {
      return encodeResponse(message);
    } else {
      return null;
    }
  }

  /// Serializes a message.
  void serialize(CoapDatagramWriter writer, CoapMessage message, int code);
}
