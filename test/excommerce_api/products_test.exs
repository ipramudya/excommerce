defmodule ExcommerceApi.ProductsTest do
  use ExcommerceApi.DataCase

  alias ExcommerceApi.Products

  describe "discounts" do
    alias ExcommerceApi.Products.Discount

    import ExcommerceApi.ProductsFixtures

    @invalid_attrs %{until: nil, percentage: nil}

    test "list_discounts/0 returns all discounts" do
      discount = discount_fixture()
      assert Products.list_discounts() == [discount]
    end

    test "get_discount!/1 returns the discount with given id" do
      discount = discount_fixture()
      assert Products.get_discount!(discount.id) == discount
    end

    test "create_discount/1 with valid data creates a discount" do
      valid_attrs = %{until: ~N[2024-05-06 14:06:00], percentage: 42}

      assert {:ok, %Discount{} = discount} = Products.create_discount(valid_attrs)
      assert discount.until == ~N[2024-05-06 14:06:00]
      assert discount.percentage == 42
    end

    test "create_discount/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_discount(@invalid_attrs)
    end

    test "update_discount/2 with valid data updates the discount" do
      discount = discount_fixture()
      update_attrs = %{until: ~N[2024-05-07 14:06:00], percentage: 43}

      assert {:ok, %Discount{} = discount} = Products.update_discount(discount, update_attrs)
      assert discount.until == ~N[2024-05-07 14:06:00]
      assert discount.percentage == 43
    end

    test "update_discount/2 with invalid data returns error changeset" do
      discount = discount_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_discount(discount, @invalid_attrs)
      assert discount == Products.get_discount!(discount.id)
    end

    test "delete_discount/1 deletes the discount" do
      discount = discount_fixture()
      assert {:ok, %Discount{}} = Products.delete_discount(discount)
      assert_raise Ecto.NoResultsError, fn -> Products.get_discount!(discount.id) end
    end

    test "change_discount/1 returns a discount changeset" do
      discount = discount_fixture()
      assert %Ecto.Changeset{} = Products.change_discount(discount)
    end
  end

  describe "products" do
    alias ExcommerceApi.Products.Product

    import ExcommerceApi.ProductsFixtures

    @invalid_attrs %{name: nil, description: nil, price: nil, stock: nil, sku_number: nil}

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Products.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Products.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{name: "some name", description: "some description", price: "120.5", stock: 42, sku_number: "some sku_number"}

      assert {:ok, %Product{} = product} = Products.create_product(valid_attrs)
      assert product.name == "some name"
      assert product.description == "some description"
      assert product.price == Decimal.new("120.5")
      assert product.stock == 42
      assert product.sku_number == "some sku_number"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description", price: "456.7", stock: 43, sku_number: "some updated sku_number"}

      assert {:ok, %Product{} = product} = Products.update_product(product, update_attrs)
      assert product.name == "some updated name"
      assert product.description == "some updated description"
      assert product.price == Decimal.new("456.7")
      assert product.stock == 43
      assert product.sku_number == "some updated sku_number"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_product(product, @invalid_attrs)
      assert product == Products.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Products.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Products.change_product(product)
    end
  end
end
