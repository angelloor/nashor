import { angelAnimations } from '@angel/animations';
import { AngelAlertType } from '@angel/components/alert';
import {
  ActionAngelConfirmation,
  AngelConfirmationService
} from '@angel/services/confirmation';
import { OverlayRef } from '@angular/cdk/overlay';
import { ChangeDetectorRef, Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Store } from '@ngrx/store';
import { AppInitialData, MessageAPI } from 'app/core/app/app.type';
import { LayoutService } from 'app/layout/layout.service';
import { NotificationService } from 'app/shared/notification/notification.service';
import { Subject, takeUntil } from 'rxjs';
import { itemCategory } from '../../item-category/item-category.data';
import { ItemCategoryService } from '../../item-category/item-category.service';
import { ItemCategory } from '../../item-category/item-category.types';
import { ItemService } from '../item.service';
import { Item } from '../item.types';
import { ModalItemService } from './modal-item.service';

@Component({
  selector: 'app-modal-item',
  templateUrl: './modal-item.component.html',
  styleUrls: ['./modal-item.component.scss'],
  animations: angelAnimations,
})
export class ModalItemComponent implements OnInit {
  listItemCategory: ItemCategory[] = [];
  selectedItemCategory: ItemCategory = itemCategory;
  id_company: string = '';

  id_item: string = '';

  nameEntity: string = 'Artículo';
  private data!: AppInitialData;

  editMode: boolean = false;
  /**
   * Alert
   */
  alert: { type: AngelAlertType; message: string } = {
    type: 'error',
    message: '',
  };
  showAlert: boolean = false;
  /**
   * Alert
   */
  item!: Item;
  itemForm!: FormGroup;

  private _tagsPanelOverlayRef!: OverlayRef;
  private _unsubscribeAll: Subject<any> = new Subject<any>();
  /**
   * isOpenModal
   */
  isOpenModal: boolean = false;
  /**
   * isOpenModal
   */
  /**
   * Constructor
   */
  constructor(
    @Inject(MAT_DIALOG_DATA) public _data: any,
    private _store: Store<{ global: AppInitialData }>,
    private _changeDetectorRef: ChangeDetectorRef,
    private _itemService: ItemService,
    private _formBuilder: FormBuilder,
    private _notificationService: NotificationService,
    private _angelConfirmationService: AngelConfirmationService,
    private _layoutService: LayoutService,
    private _itemCategoryService: ItemCategoryService,
    private _modalItemService: ModalItemService
  ) {}

  /** ----------------------------------------------------------------------------------------------------- */
  /** @ Lifecycle hooks
	  /** ----------------------------------------------------------------------------------------------------- */

  /**
   * On init
   */
  ngOnInit(): void {
    this.id_item = this._data.id_item;
    /**
     * isOpenModal
     */
    this._layoutService.isOpenModal$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_isOpenModal: boolean) => {
        this.isOpenModal = _isOpenModal;
      });
    /**
     * isOpenModal
     */
    /**
     * Subscribe to user changes of state
     */
    this._store.pipe(takeUntil(this._unsubscribeAll)).subscribe((state) => {
      this.data = state.global;
      this.id_company = this.data.user.company.id_company;
    });
    /**
     * Create the item form
     */
    this.itemForm = this._formBuilder.group({
      id_item: [''],
      id_company: [''],
      id_item_category: ['', [Validators.required]],
      name_item: ['', [Validators.required, Validators.maxLength(100)]],
      description_item: ['', [Validators.required, Validators.maxLength(250)]],
    });
    /**
     * byCompanyQueryRead
     */
    this._itemService
      .specificReadInLocal(this.id_item)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe();
    /**
     * Get the item
     */
    this._itemService.item$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((item: Item) => {
        /**
         * Get the item
         */
        this.item = item;

        // ItemCategory
        this._itemCategoryService
          .byCompanyQueryRead(this.id_company, '*')
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe((item_categorys: ItemCategory[]) => {
            this.listItemCategory = item_categorys;

            this.selectedItemCategory = this.listItemCategory.find(
              (item) =>
                item.id_item_category ==
                this.item.item_category.id_item_category
            )!;
          });

        /**
         * Patch values to the form
         */
        this.patchForm();
        /**
         * Toggle the edit mode off
         */
        this.toggleEditMode(false);
        /**
         * Mark for check
         */
        this._changeDetectorRef.markForCheck();
      });
  }
  /**
   * Pacth the form with the information of the database
   */
  patchForm(): void {
    this.itemForm.patchValue({
      ...this.item,
      id_company: this.item.company.id_company,
      id_item_category: this.item.item_category.id_item_category,
    });
  }
  /**
   * On destroy
   */
  ngOnDestroy(): void {
    /**
     * Unsubscribe from all subscriptions
     */
    this._unsubscribeAll.next(0);
    this._unsubscribeAll.complete();
    /**
     * Dispose the overlays if they are still on the DOM
     */
    if (this._tagsPanelOverlayRef) {
      this._tagsPanelOverlayRef.dispose();
    }
  }

  /** ----------------------------------------------------------------------------------------------------- */
  /** @ Public methods
	  /** ----------------------------------------------------------------------------------------------------- */
  /**
   * Toggle edit mode
   * @param editMode
   */
  toggleEditMode(editMode: boolean | null = null): void {
    this.patchForm();

    if (editMode === null) {
      this.editMode = !this.editMode;
    } else {
      this.editMode = editMode;
    }
    /**
     * Mark for check
     */
    this._changeDetectorRef.markForCheck();
  }

  /**
   * Update the item
   */
  updateItem(): void {
    /**
     * Get the item
     */
    const id_user_ = this.data.user.id_user;
    let item = this.itemForm.getRawValue();
    /**
     * Delete whitespace (trim() the atributes type string)
     */
    item = {
      ...item,
      id_user_: parseInt(id_user_),
      id_item: parseInt(item.id_item),
      company: {
        id_company: parseInt(item.id_company),
      },
      item_category: {
        id_item_category: parseInt(item.id_item_category),
      },
    };
    /**
     * Update
     */
    this._itemService
      .update(item)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (_item: Item) => {
          if (_item) {
            this._notificationService.success(
              'Artículo actualizada correctamente'
            );
            /**
             * Toggle the edit mode off
             */
            this.toggleEditMode(false);
          } else {
            this._notificationService.error(
              '¡Error interno!, consulte al administrador.'
            );
          }
        },
        error: (error: { error: MessageAPI }) => {
          this._notificationService.error(
            !error.error
              ? '¡Error interno!, consulte al administrador.'
              : !error.error.description
              ? '¡Error interno!, consulte al administrador.'
              : error.error.description
          );
        },
      });
  }
  /**
   * Delete the item
   */
  deleteItem(): void {
    this._angelConfirmationService
      .open({
        title: 'Eliminar artículo',
        message:
          '¿Estás seguro de que deseas eliminar esta artículo? ¡Esta acción no se puede deshacer!',
      })
      .afterClosed()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((confirm: ActionAngelConfirmation) => {
        if (confirm === 'confirmed') {
          /**
           * Get the current item's id
           */
          const id_user_ = this.data.user.id_user;
          const id_item = this.item.id_item;
          /**
           * Delete
           */
          this._itemService
            .delete(id_user_, id_item)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe({
              next: (response: boolean) => {
                if (response) {
                  /**
                   * Return if the item wasn't deleted...
                   */
                  this._notificationService.success(
                    'Artículo eliminada correctamente'
                  );
                  /**
                   * Toggle the edit mode off
                   */
                  this.toggleEditMode(false);
                } else {
                  this._notificationService.error(
                    '¡Error interno!, consulte al administrador.'
                  );
                }
              },
              error: (error: { error: MessageAPI }) => {
                this._notificationService.error(
                  !error.error
                    ? '¡Error interno!, consulte al administrador.'
                    : !error.error.description
                    ? '¡Error interno!, consulte al administrador.'
                    : error.error.description
                );
              },
            });
          /**
           * Mark for check
           */
          this._changeDetectorRef.markForCheck();
        }
        this._layoutService.setOpenModal(false);
      });
  }
  /**
   * closeModalItem
   */
  closeModalItem(): void {
    this._modalItemService.closeModalItem();
  }
}
