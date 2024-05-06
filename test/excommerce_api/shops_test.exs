defmodule ExcommerceApi.ShopsTest do
  use ExcommerceApi.DataCase

  alias ExcommerceApi.Shops

  describe "shops" do
    alias ExcommerceApi.Shops.Shop

    import ExcommerceApi.ShopsFixtures

    @invalid_attrs %{name: nil, bio: nil, contact: nil}

    test "list_shops/0 returns all shops" do
      shop = shop_fixture()
      assert Shops.list_shops() == [shop]
    end

    test "get_shop!/1 returns the shop with given id" do
      shop = shop_fixture()
      assert Shops.get_shop!(shop.id) == shop
    end

    test "create_shop/1 with valid data creates a shop" do
      valid_attrs = %{name: "some name", bio: "some bio", contact: "some contact"}

      assert {:ok, %Shop{} = shop} = Shops.create_shop(valid_attrs)
      assert shop.name == "some name"
      assert shop.bio == "some bio"
      assert shop.contact == "some contact"
    end

    test "create_shop/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Shops.create_shop(@invalid_attrs)
    end

    test "update_shop/2 with valid data updates the shop" do
      shop = shop_fixture()
      update_attrs = %{name: "some updated name", bio: "some updated bio", contact: "some updated contact"}

      assert {:ok, %Shop{} = shop} = Shops.update_shop(shop, update_attrs)
      assert shop.name == "some updated name"
      assert shop.bio == "some updated bio"
      assert shop.contact == "some updated contact"
    end

    test "update_shop/2 with invalid data returns error changeset" do
      shop = shop_fixture()
      assert {:error, %Ecto.Changeset{}} = Shops.update_shop(shop, @invalid_attrs)
      assert shop == Shops.get_shop!(shop.id)
    end

    test "delete_shop/1 deletes the shop" do
      shop = shop_fixture()
      assert {:ok, %Shop{}} = Shops.delete_shop(shop)
      assert_raise Ecto.NoResultsError, fn -> Shops.get_shop!(shop.id) end
    end

    test "change_shop/1 returns a shop changeset" do
      shop = shop_fixture()
      assert %Ecto.Changeset{} = Shops.change_shop(shop)
    end
  end
end
