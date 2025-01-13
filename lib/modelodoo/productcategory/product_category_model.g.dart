

part of 'product_category_model.dart';


ProductCategoryModel _$ProductCategoryModelFromJson(Map<String, dynamic> json) => ProductCategoryModel(
name: json['name'] as dynamic,
);


Map<String, dynamic> _$ProductCategoryModelToJson(ProductCategoryModel instance) =>
<String, dynamic>{
'name': instance.name,
};
