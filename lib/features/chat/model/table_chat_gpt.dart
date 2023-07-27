import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'package:http/http.dart' as http;

part 'table_chat_gpt.g.dart';

const SqfEntityTable tableChatGpt = SqfEntityTable(
  modelName: 'chatGpt',
  tableName: 'chatGpt',
  primaryKeyName: 'id',
  useSoftDeleting: false,
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  fields: [
    SqfEntityField('chatName', DbType.text),
    SqfEntityField('text', DbType.text),
    SqfEntityField('role', DbType.text),
    SqfEntityField('date', DbType.datetime),
  ]
);

const seqIdentity = SqfEntitySequence(
  sequenceName: 'identity',
);

@SqfEntityBuilder(myDbModel)
const myDbModel = SqfEntityModel(
  modelName: 'ChatGptDatabase',
  databaseName: 'ChatGptDatabase.db',
  sequences: [seqIdentity],
  databaseTables: [tableChatGpt],
);