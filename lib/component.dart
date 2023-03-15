part of credit_card_form;

class CreditCardForm extends StatefulWidget {
  final String? cardNumberLabel;
  final String? cardHolderLabel;
  final String? expiredDateLabel;
  final String? cvcLabel;
  final double fontSize;
  final CreditCardTheme? theme;
  final Function(CreditCardResult) onChanged;
  final Map<String, GlobalKey<FormState>> formStateKeys;
  final Map<String, bool> autoValidates;
  const CreditCardForm({
    super.key,
    required this.formStateKeys,
    required this.autoValidates,
    this.theme,
    required this.onChanged,
    this.cardNumberLabel,
    this.cardHolderLabel,
    this.expiredDateLabel,
    this.cvcLabel,
    this.fontSize = 16,
  });

  @override
  State<CreditCardForm> createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  Map<String, dynamic> params = {
    cardKey: '',
    expiredDateKey: '',
    cardHolderNameKey: '',
    cvcKey: '',
    nicknameKey: ''
  };

  Map cardImg = {
    "img": 'credit_card.png',
    "width": 30.0,
  };

  String error = '';
  bool? isCardNumberValidated, isExpiryValidated, isCvcValidated;

  static const String cardKey = 'card',
      expiredDateKey = 'expired_date',
      cardHolderNameKey = 'card_holder_name',
      cvcKey = 'cvc',
      nicknameKey = 'nickname';
  Map<String, FocusNode> focusNodes = {
    cardKey: FocusNode(),
    expiredDateKey: FocusNode(),
    cardHolderNameKey: FocusNode(),
    cvcKey: FocusNode(),
    nicknameKey: FocusNode()
  };
  CardType? cardType;

  Map<String, TextEditingController> controllers = {
    cardKey: TextEditingController(),
    expiredDateKey: TextEditingController(),
    cardHolderNameKey: TextEditingController(),
    cvcKey: TextEditingController(),
    nicknameKey: TextEditingController()
  };

  addTextFieldFocusListener(String key) {
    focusNodes[key]!.addListener(() {
      if (!focusNodes[key]!.hasFocus) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {
            widget.autoValidates[key] = true;
          });
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    addTextFieldFocusListener(cardKey);
    addTextFieldFocusListener(expiredDateKey);
    addTextFieldFocusListener(cardHolderNameKey);
    addTextFieldFocusListener(cvcKey);
    addTextFieldFocusListener(nicknameKey);
  }

  @override
  Widget build(BuildContext context) {
    CreditCardTheme theme = widget.theme ?? CreditCardLightTheme();
    return Column(
      children: [
        textInput(
          controller: controllers[cardKey],
          autoValidate: widget.autoValidates[cardKey]!,
          focusNode: focusNodes[cardKey]!,
          label: widget.cardNumberLabel ?? 'Card Number',
          validator: (value) {
            String? validateMsg = cardNumberValidator(value);
            validateMsg == null
                ? isCardNumberValidated = true
                : isCardNumberValidated = false;
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              setState(() {});
            });
            return validateMsg;
          },
          key: cardKey,
          formKey: widget.formStateKeys[cardKey]!,
          bottom: 1,
          formatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
            CardNumberInputFormatter(),
          ],
          onChanged: (val) {
            Map img = CardUtils.getCardIcon(val);
            CardType type =
                CardUtils.getCardTypeFrmNumber(val.replaceAll(' ', ''));
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              setState(() {
                if (val.length > 21) {
                  widget.autoValidates[cardKey] = true;
                }
                cardImg = img;
                cardType = type;
              });
            });
            emitResult();
          },
          suffixIcon: isCardNumberValidated == null
              ? const SizedBox()
              : isCardNumberValidated!
                  ? const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    )
                  : const Icon(Icons.info_outline),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'images/${cardImg['img']}',
              package: 'credit_card_form',
              width: cardImg['width'] as double?,
            ),
          ),
        ),
        const SizedBox(height: 12),
        textInput(
          label: widget.cardHolderLabel ?? 'Card holder name',
          autoValidate: widget.autoValidates[cardHolderNameKey]!,
          focusNode: focusNodes[cardHolderNameKey]!,
          controller: controllers[cardHolderNameKey],
          key: cardHolderNameKey,
          formKey: widget.formStateKeys[cardHolderNameKey]!,
          validator: (value) => emptyValidator(value, 'Account Title'),
          bottom: 1,
          onChanged: (val) {
            emitResult();
          },
          keyboardType: TextInputType.name,
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 4,
              child: textInput(
                label: widget.expiredDateLabel ?? 'MM/YY',
                autoValidate: widget.autoValidates[expiredDateKey]!,
                focusNode: focusNodes[expiredDateKey]!,
                hintText: 'MM / YY',
                right: 1,
                validator: (value) {
                  String? validateMsg = cardExpiryDateValidator(value);
                  validateMsg == null
                      ? isExpiryValidated = true
                      : isExpiryValidated = false;
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    setState(() {});
                  });
                  return validateMsg;
                },
                key: expiredDateKey,
                formKey: widget.formStateKeys[expiredDateKey]!,
                onChanged: (val) {
                  if (val.length > 4) {
                    widget.autoValidates[expiredDateKey] = true;
                  }
                  emitResult();
                },
                suffixIcon: isExpiryValidated == null
                    ? const SizedBox()
                    : isExpiryValidated!
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          )
                        : const Icon(Icons.info_outline),
                controller: controllers[expiredDateKey],
                formatters: [
                  CardExpirationFormatter(),
                  LengthLimitingTextInputFormatter(5)
                ],
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              flex: 4,
              child: textInput(
                  label: widget.cvcLabel ?? 'CVC',
                  focusNode: focusNodes[cvcKey]!,
                  autoValidate: widget.autoValidates[cvcKey]!,
                  hintText: '***',
                  key: cvcKey,
                  formKey: widget.formStateKeys[cvcKey]!,
                  validator: (value) {
                    String? validateMsg = cvcValidator(value);
                    validateMsg == null
                        ? isCvcValidated = true
                        : isCvcValidated = false;
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      setState(() {});
                    });
                    return validateMsg;
                  },
                  controller: controllers[cvcKey],
                  password: true,
                  onChanged: (val) {
                    if (val.length > 2) {
                      widget.autoValidates[cvcKey] = true;
                    }
                    emitResult();
                  },
                  formatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3)
                  ],
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      isCvcValidated == null
                          ? const SizedBox()
                          : isCvcValidated!
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : const Icon(Icons.info_outline),
                      CustomToolTip(theme: theme),
                    ],
                  )),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 8),
          child: textInput(
            label: 'Add a card nickname',
            autoValidate: widget.autoValidates[nicknameKey]!,
            key: nicknameKey,
            formKey: widget.formStateKeys[nicknameKey]!,
            focusNode: focusNodes[nicknameKey]!,
            keyboardType: TextInputType.name,
            controller: controllers[nicknameKey],
            validator: (value) => emptyValidator(value, 'Card Nickname'),
            onChanged: (val) => emitResult(),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Example: My Gold Card',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).hintColor,
                fontWeight: FontWeight.w600),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    controllers.forEach((key, value) => value.dispose());
    super.dispose();
  }

  emitResult() {
    List res = params['expired_date'].split('/');
    CreditCardResult result = CreditCardResult(
        cardNumber: params['card'].replaceAll(' ', ''),
        cvc: params['cvc'],
        cardHolderName: params['card_holder_name'],
        expirationMonth: res[0] ?? '',
        isValid: false,
        expirationYear: res.asMap().containsKey(1) ? res[1] : '',
        cardType: cardType,
        nickName: params['nickname']);
    widget.onChanged(result);
  }

  Widget textInput({
    required String label,
    required String key,
    required GlobalKey<FormState> formKey,
    required bool autoValidate,
    double left = 0,
    double right = 0,
    double bottom = 0,
    double top = 0,
    int? maxLength,
    List<TextInputFormatter>? formatters,
    TextInputType? keyboardType,
    bool? password,
    Function(String)? onChanged,
    Widget? suffixIcon,
    Widget? prefixIcon,
    String? hintText,
    required FocusNode focusNode,
    String? Function(String?)? validator,
    TextEditingController? controller,
  }) {
    CreditCardTheme theme = widget.theme ?? CreditCardLightTheme();
    return Form(
      key: formKey,
      autovalidateMode: autoValidate
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        validator: validator,
        style: TextStyle(
          color: theme.textColor,
          fontSize: widget.fontSize,
        ),
        maxLength: maxLength,
        onChanged: (value) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            setState(() {
              params[key] = value;
            });
          });
          if (onChanged != null) {
            onChanged(value);
          }
        },
        obscureText: password ?? false,
        inputFormatters: formatters ?? [],
        keyboardType: keyboardType ?? TextInputType.number,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          errorMaxLines: 1,
          errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
          contentPadding: const EdgeInsets.all(15),
          label: Text(label),
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: theme.borderColor),
              borderRadius: BorderRadius.circular(8)),
          border: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: theme.borderColor),
              borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: theme.borderColor),
              borderRadius: BorderRadius.circular(8)),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1, color: Theme.of(context).colorScheme.error),
              borderRadius: BorderRadius.circular(8)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1, color: Theme.of(context).colorScheme.error),
              borderRadius: BorderRadius.circular(8)),
          hintStyle: TextStyle(
            color: theme.labelColor,
            fontSize: widget.fontSize,
          ),
        ),
      ),
    );
  }
}
