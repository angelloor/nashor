import { angelAnimations } from '@angel/animations';
import { AngelAlertType } from '@angel/components/alert';
import {
  ActionAngelConfirmation,
  AngelConfirmationService,
} from '@angel/services/confirmation';
import { OverlayRef } from '@angular/cdk/overlay';
import { DOCUMENT } from '@angular/common';
import { ChangeDetectorRef, Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatDrawerToggleResult } from '@angular/material/sidenav';
import { ActivatedRoute, Router } from '@angular/router';
import { Store } from '@ngrx/store';
import { AppInitialData, MessageAPI } from 'app/core/app/app.type';
import { LayoutService } from 'app/layout/layout.service';
import { NotificationService } from 'app/shared/notification/notification.service';
import { filter, fromEvent, merge, Subject, takeUntil } from 'rxjs';
import { ItemCategoryService } from '../item-category.service';
import { ItemCategory } from '../item-category.types';
import { ItemCategoryListComponent } from '../list/list.component';

@Component({
  selector: 'item-category-details',
  templateUrl: './details.component.html',
  animations: angelAnimations,
})
export class ItemCategoryDetailsComponent implements OnInit {
  nameEntity: string = 'Categoría del artículo';
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
  itemCategory!: ItemCategory;
  itemCategoryForm!: FormGroup;
  private itemCategorys!: ItemCategory[];

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
    private _store: Store<{ global: AppInitialData }>,
    private _changeDetectorRef: ChangeDetectorRef,
    private _itemCategoryListComponent: ItemCategoryListComponent,
    private _itemCategoryService: ItemCategoryService,
    @Inject(DOCUMENT) private _document: any,
    private _formBuilder: FormBuilder,
    private _activatedRoute: ActivatedRoute,
    private _router: Router,
    private _notificationService: NotificationService,
    private _angelConfirmationService: AngelConfirmationService,
    private _layoutService: LayoutService
  ) {}

  /** ----------------------------------------------------------------------------------------------------- */
  /** @ Lifecycle hooks
	  /** ----------------------------------------------------------------------------------------------------- */

  /**
   * On init
   */
  ngOnInit(): void {
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
    });
    /**
     * Open the drawer
     */
    this._itemCategoryListComponent.matDrawer.open();
    /**
     * Create the itemCategory form
     */
    this.itemCategoryForm = this._formBuilder.group({
      id_item_category: [''],
      id_company: [''],
      name_item_category: [
        '',
        [Validators.required, Validators.maxLength(100)],
      ],
      description_item_category: [
        '',
        [Validators.required, Validators.maxLength(250)],
      ],
    });
    /**
     * Get the itemCategorys
     */
    this._itemCategoryService.itemCategorys$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((itemCategorys: ItemCategory[]) => {
        this.itemCategorys = itemCategorys;
        /**
         * Mark for check
         */
        this._changeDetectorRef.markForCheck();
      });
    /**
     * Get the itemCategory
     */
    this._itemCategoryService.itemCategory$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((itemCategory: ItemCategory) => {
        /**
         * Open the drawer in case it is closed
         */
        this._itemCategoryListComponent.matDrawer.open();
        /**
         * Get the itemCategory
         */
        this.itemCategory = itemCategory;

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
    /**
     * Shortcuts
     */
    merge(
      fromEvent(this._document, 'keydown').pipe(
        takeUntil(this._unsubscribeAll),
        filter<KeyboardEvent | any>((e) => e.key === 'Escape')
      )
    )
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((keyUpOrKeyDown) => {
        /**
         * Shortcut Escape
         */
        if (!this.isOpenModal && keyUpOrKeyDown.key == 'Escape') {
          /**
           * Navigate parentUrl
           */
          const parentUrl = this._router.url.split('/').slice(0, -1).join('/');
          this._router.navigate([parentUrl]);
          /**
           * Close Drawer
           */
          this.closeDrawer();
        }
      });
    /**
     * Shortcuts
     */
  }
  /**
   * Pacth the form with the information of the database
   */
  patchForm(): void {
    this.itemCategoryForm.patchValue({
      ...this.itemCategory,
      id_company: this.itemCategory.company.id_company,
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
   * Close the drawer
   */
  closeDrawer(): Promise<MatDrawerToggleResult> {
    return this._itemCategoryListComponent.matDrawer.close();
  }
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
   * Update the itemCategory
   */
  updateItemCategory(): void {
    /**
     * Get the itemCategory
     */
    const id_user_ = this.data.user.id_user;
    let itemCategory = this.itemCategoryForm.getRawValue();
    /**
     * Delete whitespace (trim() the atributes type string)
     */
    itemCategory = {
      ...itemCategory,
      id_user_: parseInt(id_user_),
      id_item_category: parseInt(itemCategory.id_item_category),
      company: {
        id_company: parseInt(itemCategory.id_company),
      },
    };
    /**
     * Update
     */
    this._itemCategoryService
      .update(itemCategory)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (_itemCategory: ItemCategory) => {
          if (_itemCategory) {
            this._notificationService.success(
              'Categoría del artículo actualizada correctamente'
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
   * Delete the itemCategory
   */
  deleteItemCategory(): void {
    this._angelConfirmationService
      .open({
        title: 'Eliminar categoría del artículo',
        message:
          '¿Estás seguro de que deseas eliminar esta categoría del artículo? ¡Esta acción no se puede deshacer!',
      })
      .afterClosed()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((confirm: ActionAngelConfirmation) => {
        if (confirm === 'confirmed') {
          /**
           * Get the current itemCategory's id
           */
          const id_user_ = this.data.user.id_user;
          const id_item_category = this.itemCategory.id_item_category;
          /**
           * Get the next/previous itemCategory's id
           */
          const currentIndex = this.itemCategorys.findIndex(
            (item) => item.id_item_category === id_item_category
          );

          const nextIndex =
            currentIndex +
            (currentIndex === this.itemCategorys.length - 1 ? -1 : 1);
          const nextId =
            this.itemCategorys.length === 1 &&
            this.itemCategorys[0].id_item_category === id_item_category
              ? null
              : this.itemCategorys[nextIndex].id_item_category;
          /**
           * Delete
           */
          this._itemCategoryService
            .delete(id_user_, id_item_category)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe({
              next: (response: boolean) => {
                if (response) {
                  /**
                   * Return if the itemCategory wasn't deleted...
                   */
                  this._notificationService.success(
                    'Categoría del artículo eliminada correctamente'
                  );
                  /**
                   * Get the current activated route
                   */
                  let route = this._activatedRoute;
                  while (route.firstChild) {
                    route = route.firstChild;
                  }
                  /**
                   * Navigate to the next itemCategory if available
                   */
                  if (nextId) {
                    this._router.navigate(['../', nextId], {
                      relativeTo: route,
                    });
                  } else {
                    /**
                     * Otherwise, navigate to the parent
                     */
                    this._router.navigate(['../'], { relativeTo: route });
                  }
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
}
