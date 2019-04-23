import "dart:typed_data";
import "dart:math";
import "package:pointycastle/pointycastle.dart";
import "package:pointycastle/export.dart";
import "package:pointycastle/api.dart";
import "package:pointycastle/ecc/api.dart";
import "package:pointycastle/ecc/curves/secp256k1.dart";
import "package:pointycastle/key_generators/api.dart";
import "package:pointycastle/key_generators/ec_key_generator.dart";
import "package:pointycastle/random/fortuna_random.dart";

void main() {
  var keyPair = secp256k1KeyPair();
  ECPrivateKey privateKey = keyPair.privateKey;
  print(privateKey.d);
}

//97ddae0f3a25b92268175400149d65d6887b9cefaf28ea2c078e05cdc15a3c0a
//7b83ad6afb1209f3c82ebeb08c0c5fa9bf6724548506f2fb4f991e2287a77090177316ca82b0bdf70cd9dee145c3002c0da1d92626449875972a27807b73b42e


//68087b52c11f05ada1d234c9ae4047f6aee57db38511686872af3761dbfb9010
//af2f601496252506bbfe7000e5a94880b33dbce92585b8ae5c07458a395c8eedaf2f601496252506bbfe7000e5a94880b33dbce92585b8ae5c07458a395c8eed

AsymmetricKeyPair<PublicKey, PrivateKey> secp256k1KeyPair() {
  var keyParams = ECKeyGeneratorParameters(ECCurve_secp256k1());

  var random = FortunaRandom();
  random.seed(KeyParameter(_seed()));

  var generator = ECKeyGenerator();
  generator.init(ParametersWithRandom(keyParams, random));

  return generator.generateKeyPair();
}

Uint8List _seed() {
  var random = Random.secure();
  var seed = List<int>.generate(32, (_) => random.nextInt(256));
  return Uint8List.fromList(seed);
}



// TODO
// Restore the ECPrivateKey from 'd'.
