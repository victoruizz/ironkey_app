import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ironkey/app_theme.dart';
import 'package:ironkey/models/password_complexity.dart';
import 'package:ironkey/password_generator.dart';
import 'package:ironkey/pin_password_generator.dart';
import 'package:ironkey/standard_password_generator.dart';

void main() {
  runApp(IronKeyApp());
}

class IronKeyApp extends StatelessWidget {
  const IronKeyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      title: "IronKey",
      home: IronKeyScreen(),
    );
  }
}

class IronKeyScreen extends StatefulWidget {
  const IronKeyScreen({super.key});

  @override
  State<IronKeyScreen> createState() => _IronKeyScreenState();
}

class _IronKeyScreenState extends State<IronKeyScreen> {
  final TextEditingController _passwordController = TextEditingController();

  PasswordType passwordSelectedType = PasswordType.pin;
  bool isEditable = false;

  bool includeUppercase = true;
  bool includeLowercase = true;
  bool includeSymbols = false;
  bool includeNumbers = false;

  PasswordComplexity selectedComplexity = PasswordComplexity.medium;

  // Inicia com o minLength da complexidade padrão
  int passwordLength = PasswordComplexity.medium.minLength;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void copyPassword(String password) {
    Clipboard.setData(ClipboardData(text: password));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Senha copiada!')),
    );
  }

  void generatePassword() {
    late final PasswordGenerator generator;

    switch (passwordSelectedType) {
      case PasswordType.pin:
        generator = PinPasswordGenerator();
        break;
      case PasswordType.standard:
        generator = StandardPasswordGenerator(
          includeLowercase: includeLowercase,
          includeUppercase: includeUppercase,
          includeNumbers: includeNumbers,
          includeSymbols: includeSymbols,
        );
        break;
    }

    setState(() {
      _passwordController.text = generator.generate(passwordLength);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ClipOval(
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: Image.asset(
                            "assets/images/shelby.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Sua senha segura",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        enabled: isEditable,
                        controller: _passwordController,
                        maxLength: selectedComplexity.maxLength, // ← ajustado pela complexidade
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: const OutlineInputBorder(),
                          prefix: const Icon(Icons.lock),
                          suffix: _passwordController.text.isNotEmpty
                              ? IconButton(
                                  onPressed: () => copyPassword(_passwordController.text),
                                  icon: const Icon(Icons.copy),
                                )
                              : null,
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Tipo de senha"),
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile(
                              value: PasswordType.pin,
                              groupValue: passwordSelectedType,
                              title: const Text("Pin"),
                              onChanged: (value) {
                                setState(() {
                                  passwordSelectedType = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile(
                              value: PasswordType.standard,
                              groupValue: passwordSelectedType,
                              title: const Text("Senha padrão"),
                              onChanged: (value) {
                                setState(() {
                                  passwordSelectedType = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      Divider(color: colorScheme.outline),

                      Row(
                        children: [
                          Icon(isEditable ? Icons.lock_open : Icons.lock),
                          const SizedBox(width: 4),
                          const Expanded(child: Text("Permitir editar a senha?")),
                          Switch(
                            value: isEditable,
                            onChanged: (value) {
                              setState(() {
                                isEditable = value;
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 3),

                      if (isEditable) ...[
                        const SizedBox(height: 20),

                        // Dropdown de complexidade
                        DropdownButtonFormField<PasswordComplexity>(
                          value: selectedComplexity,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Complexidade da senha',
                            border: OutlineInputBorder(),
                          ),
                          items: PasswordComplexity.values.map((complexity) {
                            return DropdownMenuItem(
                              value: complexity,
                              child: Text(complexity.title),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedComplexity = value!;
                              // Reseta o tamanho para o mínimo da nova complexidade
                              passwordLength = selectedComplexity.minLength;
                            });
                          },
                        ),

                        const SizedBox(height: 12),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Tamanho da Senha: $passwordLength"),
                        ),

                        // Slider com min/max do enum
                        Slider(
                          value: passwordLength.toDouble(),
                          min: selectedComplexity.minLength.toDouble(),
                          max: selectedComplexity.maxLength.toDouble(),
                          divisions: selectedComplexity.maxLength - selectedComplexity.minLength,
                          label: passwordLength.toString(),
                          onChanged: (value) {
                            setState(() {
                              passwordLength = value.toInt();
                            });
                            generatePassword();
                          },
                        ),

                        // Checkboxes só aparecem para senha padrão
                        if (passwordSelectedType == PasswordType.standard) ...[
                          Row(
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  value: includeUppercase,
                                  onChanged: (value) => setState(() => includeUppercase = value ?? false),
                                  title: const Text("Maiúsculas"),
                                  controlAffinity: ListTileControlAffinity.leading,
                                ),
                              ),
                              Expanded(
                                child: CheckboxListTile(
                                  value: includeNumbers,
                                  onChanged: (value) => setState(() => includeNumbers = value ?? false),
                                  title: const Text("Números"),
                                  controlAffinity: ListTileControlAffinity.leading,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  value: includeLowercase,
                                  onChanged: (value) => setState(() => includeLowercase = value ?? false),
                                  title: const Text("Minúsculas"),
                                  controlAffinity: ListTileControlAffinity.leading,
                                ),
                              ),
                              Expanded(
                                child: CheckboxListTile(
                                  value: includeSymbols,
                                  onChanged: (value) => setState(() => includeSymbols = value ?? false),
                                  title: const Text("Símbolos"),
                                  controlAffinity: ListTileControlAffinity.leading,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: generatePassword,
                  child: const Text("Gerar senha"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum PasswordType { pin, standard }